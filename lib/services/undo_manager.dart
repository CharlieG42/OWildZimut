import 'package:flutter/foundation.dart';
import '../models/map_state.dart';
import '../models/symbol.dart' as symbol_model;
import '../models/layer.dart';
import 'package:flutter/material.dart' show Offset;

/// Gère l'historique des états pour les opérations undo/redo
///
/// Cette classe permet de maintenir un historique des états de la carte
/// pour permettre à l'utilisateur d'annuler ou de rétablir ses actions.
///
/// Utilisation :
/// ```dart
/// final undoManager = UndoManager();
/// 
/// // Après chaque modification de l'état
/// undoManager.pushState(newState);
/// 
/// // Pour annuler
/// final undoneState = undoManager.undo();
/// 
/// // Pour rétablir
/// final redoneState = undoManager.redo();
/// ```
class UndoManager with ChangeNotifier {
  /// Historique des états
  final List<MapState> history = [];
  
  /// Index de l'état actuel dans l'historique
  int currentIndex = -1;
  
  /// Nombre maximum d'états dans l'historique (pour limiter la mémoire)
  final int maxHistoryLength;

  /// Crée un nouveau UndoManager
  UndoManager({this.maxHistoryLength = 50});

  /// État actuel
  MapState get currentState => 
      history.isEmpty ? MapState.initial() : history[currentIndex];

  /// Peut-on annuler ?
  bool get canUndo => currentIndex > 0;

  /// Peut-on rétablir ?
  bool get canRedo => currentIndex < history.length - 1;

  /// Nombre d'états dans l'historique
  int get historyLength => history.length;

  /// Position actuelle dans l'historique
  int get currentPosition => currentIndex;

  /// Ajoute un nouvel état à l'historique
  ///
  /// Cette méthode doit être appelée après chaque modification de l'état
  /// de la carte qui doit pouvoir être annulée.
  void pushState(MapState state) {
    // Supprimer les états après currentIndex (si on a fait undo puis une nouvelle action)
    if (currentIndex < history.length - 1) {
      history.removeRange(currentIndex + 1, history.length);
    }
    
    // Ajouter le nouvel état
    history.add(state);
    currentIndex = history.length - 1;
    
    // Limiter la taille de l'historique
    if (history.length > maxHistoryLength) {
      history.removeAt(0);
      currentIndex--;
    }
    
    notifyListeners();
  }

  /// Annule la dernière action
  ///
  /// Retourne le nouvel état après annulation, ou null si impossible.
  MapState? undo() {
    if (!canUndo) return null;
    
    currentIndex--;
    notifyListeners();
    return history[currentIndex];
  }

  /// Rétablit la dernière action annulée
  ///
  /// Retourne le nouvel état après rétablissement, ou null si impossible.
  MapState? redo() {
    if (!canRedo) return null;
    
    currentIndex++;
    notifyListeners();
    return history[currentIndex];
  }

  /// Va à une position spécifique dans l'historique
  ///
  /// [index] : L'index dans l'historique (0 = état initial)
  /// Retourne le nouvel état, ou null si l'index est invalide
  MapState? goTo(int index) {
    if (index < 0 || index >= history.length) return null;
    
    currentIndex = index;
    notifyListeners();
    return history[currentIndex];
  }

  /// Efface l'historique
  void clear() {
    history.clear();
    currentIndex = -1;
    notifyListeners();
  }

  /// Réinitialise avec un nouvel état initial
  void reset(MapState initialState) {
    history.clear();
    history.add(initialState);
    currentIndex = 0;
    notifyListeners();
  }

  /// Récupère un état à une position donnée
  MapState? getStateAt(int index) {
    if (index < 0 || index >= history.length) return null;
    return history[index];
  }

  /// Supprime tous les états avant une certaine position
  void trimBefore(int index) {
    if (index <= 0) return;
    
    final statesToKeep = history.sublist(index);
    history.clear();
    history.addAll(statesToKeep);
    currentIndex -= index;
    
    if (currentIndex < 0) currentIndex = 0;
    
    notifyListeners();
  }

  /// Supprime tous les états après une certaine position
  void trimAfter(int index) {
    if (index >= history.length - 1) return;
    
    history.removeRange(index + 1, history.length);
    
    if (currentIndex > index) currentIndex = index;
    
    notifyListeners();
  }
}

/// Action qui peut être annulée
///
/// Cette classe représente une action qui peut être annulée et rétablie.
/// Elle est utilisée pour implémenter un système d'undo/redo plus avancé
/// basé sur les actions plutôt que sur les états.
class UndoableAction {
  /// Description de l'action (pour l'interface utilisateur)
  String get description;
  
  /// Applique l'action à un état
  MapState apply(MapState state);
  
  /// Annule l'action sur un état
  MapState undo(MapState state);
}

/// Gestionnaire d'actions undo/redo
///
/// Alternative à UndoManager qui stocke les actions plutôt que les états.
/// Cela peut être plus efficace pour certaines applications.
class ActionUndoManager with ChangeNotifier {
  final List<UndoableAction> actions = [];
  final List<UndoableAction> undoneActions = [];
  final int maxActions;

  ActionUndoManager({this.maxActions = 50});

  /// Peut-on annuler ?
  bool get canUndo => actions.isNotEmpty;

  /// Peut-on rétablir ?
  bool get canRedo => undoneActions.isNotEmpty;

  /// Ajoute une nouvelle action
  void pushAction(UndoableAction action) {
    actions.add(action);
    undoneActions.clear(); // Effacer les actions annulées
    
    if (actions.length > maxActions) {
      actions.removeAt(0);
    }
    
    notifyListeners();
  }

  /// Annule la dernière action
  MapState undo(MapState currentState) {
    if (!canUndo) return currentState;
    
    final action = actions.removeLast();
    undoneActions.add(action);
    
    notifyListeners();
    return action.undo(currentState);
  }

  /// Rétablit la dernière action annulée
  MapState redo(MapState currentState) {
    if (!canRedo) return currentState;
    
    final action = undoneActions.removeLast();
    actions.add(action);
    
    notifyListeners();
    return action.apply(currentState);
  }

  /// Efface l'historique
  void clear() {
    actions.clear();
    undoneActions.clear();
    notifyListeners();
  }
}

/// Actions prédéfinies

/// Action pour ajouter un symbole
class AddSymbolAction implements UndoableAction {
  final symbol_model.MapSymbol symbol;
  final int layerIndex;

  AddSymbolAction(this.symbol, this.layerIndex);

  @override
  String get description => 'Ajouter symbole';

  @override
  MapState apply(MapState state) {
    return state.addSymbolToLayer(
      state.layers[layerIndex].id,
      symbol,
    );
  }

  @override
  MapState undo(MapState state) {
    return state.removeSymbol(symbol.id);
  }
}

/// Action pour supprimer un symbole
class RemoveSymbolAction implements UndoableAction {
  final String symbolId;
  final symbol_model.MapSymbol symbol;
  final int layerIndex;

  RemoveSymbolAction(this.symbolId, this.symbol, this.layerIndex);

  @override
  String get description => 'Supprimer symbole';

  @override
  MapState apply(MapState state) {
    return state.removeSymbol(symbolId);
  }

  @override
  MapState undo(MapState state) {
    return state.addSymbolToLayer(state.layers[layerIndex].id, symbol);
  }
}

/// Action pour déplacer un symbole
class MoveSymbolAction implements UndoableAction {
  final String symbolId;
  final Offset oldPosition;
  final Offset newPosition;

  MoveSymbolAction(this.symbolId, this.oldPosition, this.newPosition);

  @override
  String get description => 'Déplacer symbole';

  @override
  MapState apply(MapState state) {
    return state.moveSymbol(symbolId, newPosition - oldPosition);
  }

  @override
  MapState undo(MapState state) {
    return state.moveSymbol(symbolId, oldPosition - newPosition);
  }
}

/// Action pour modifier les propriétés d'un symbole
class UpdateSymbolAction implements UndoableAction {
  final String symbolId;
  final symbol_model.MapSymbol oldSymbol;
  final symbol_model.MapSymbol newSymbol;

  UpdateSymbolAction(this.symbolId, this.oldSymbol, this.newSymbol);

  @override
  String get description => 'Modifier symbole';

  @override
  MapState apply(MapState stat
