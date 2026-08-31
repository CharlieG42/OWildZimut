import 'package:flutter/foundation.dart';
import '../models/map_state.dart';
import '../models/layer.dart';
import '../models/symbol.dart' as symbol_model;

/// Gère l'historique des états pour les opérations undo/redo
///
/// Cette classe permet de maintenir un historique des états de la carte
/// pour permettre à l'utilisateur d'annuler ou de rétablir ses actions.
///
/// Utilisation :
/// ```dart
/// final mapUndoManager = MapUndoManager();
/// 
/// // Après chaque modification de l'état
/// mapUndoManager.pushState(newState);
/// 
/// // Pour annuler
/// final undoneState = mapUndoManager.undo();
/// 
/// // Pour rétablir
/// final redoneState = mapUndoManager.redo();
/// ```
class MapUndoManager with ChangeNotifier {
  /// Historique des états
  final List<MapState> _history = [];
  
  /// Index de l'état actuel dans l'historique
  int _currentIndex = -1;
  
  /// Nombre maximum d'états dans l'historique (pour limiter la mémoire)
  final int maxHistoryLength;

  /// Crée un nouveau MapUndoManager
  MapUndoManager({this.maxHistoryLength = 50});

  /// État actuel
  MapState get currentState => 
      _history.isEmpty ? MapState.initial() : _history[_currentIndex];

  /// Peut-on annuler ?
  bool get canUndo => _currentIndex > 0;

  /// Peut-on rétablir ?
  bool get canRedo => _currentIndex < _history.length - 1;

  /// Nombre d'états dans l'historique
  int get historyLength => _history.length;

  /// Position actuelle dans l'historique
  int get currentPosition => _currentIndex;

  /// Ajoute un nouvel état à l'historique
  ///
  /// Cette méthode doit être appelée après chaque modification de l'état
  /// de la carte qui doit pouvoir être annulée.
  void pushState(MapState state) {
    // Supprimer les états après currentIndex (si on a fait undo puis une nouvelle action)
    if (_currentIndex < _history.length - 1) {
      _history.removeRange(_currentIndex + 1, _history.length);
    }
    
    // Ajouter le nouvel état
    _history.add(state);
    _currentIndex = _history.length - 1;
    
    // Limiter la taille de l'historique
    if (_history.length > maxHistoryLength) {
      _history.removeAt(0);
      _currentIndex--;
    }
    
    notifyListeners();
  }

  /// Annule la dernière action
  ///
  /// Retourne le nouvel état après annulation, ou null si impossible.
  MapState? undo() {
    if (!canUndo) return null;
    
    _currentIndex--;
    notifyListeners();
    return _history[_currentIndex];
  }

  /// Rétablit la dernière action annulée
  ///
  /// Retourne le nouvel état après rétablissement, ou null si impossible.
  MapState? redo() {
    if (!canRedo) return null;
    
    _currentIndex++;
    notifyListeners();
    return _history[_currentIndex];
  }

  /// Va à une position spécifique dans l'historique
  ///
  /// [index] : L'index dans l'historique (0 = état initial)
  /// Retourne le nouvel état, ou null si l'index est invalide
  MapState? goTo(int index) {
    if (index < 0 || index >= _history.length) return null;
    
    _currentIndex = index;
    notifyListeners();
    return _history[_currentIndex];
  }

  /// Efface l'historique
  void clear() {
    _history.clear();
    _currentIndex = -1;
    notifyListeners();
  }

  /// Réinitialise avec un nouvel état initial
  void reset(MapState initialState) {
    _history.clear();
    _history.add(initialState);
    _currentIndex = 0;
    notifyListeners();
  }

  /// Récupère un état à une position donnée
  MapState? getStateAt(int index) {
    if (index < 0 || index >= _history.length) return null;
    return _history[index];
  }

  /// Supprime tous les états avant une certaine position
  void trimBefore(int index) {
    if (index <= 0) return;
    
    final statesToKeep = _history.sublist(index);
    _history.clear();
    _history.addAll(statesToKeep);
    _currentIndex -= index;
    
    if (_currentIndex < 0) _currentIndex = 0;
    
    notifyListeners();
  }

  /// Supprime tous les états après une certaine position
  void trimAfter(int index) {
    if (index >= _history.length - 1) return;
    
    _history.removeRange(index + 1, _history.length);
    
    if (_currentIndex > index) _currentIndex = index;
    
    notifyListeners();
  }
}

/// Action qui peut être annulée
///
/// Cette classe représente une action qui peut être annulée et rétablie.
/// Elle est utilisée pour implémenter un système d'undo/redo plus avancé
/// basé sur les actions plutôt que sur les états.
abstract class UndoableAction {
  /// Description de l'action (pour l'interface utilisateur)
  String get description;
  
  /// Applique l'action à un état
  MapState apply(MapState state);
  
  /// Annule l'action sur un état
  MapState undo(MapState state);
}

/// Gestionnaire d'actions undo/redo
///
/// Alternative à MapUndoManager qui stocke les actions plutôt que les états.
/// Cela peut être plus efficace pour certaines applications.
class MapActionUndoManager with ChangeNotifier {
  final List<UndoableAction> _actions = [];
  final List<UndoableAction> _undoneActions = [];
  final int maxActions;

  MapActionUndoManager({this.maxActions = 50});

  /// Peut-on annuler ?
  bool get canUndo => _actions.isNotEmpty;

  /// Peut-on rétablir ?
  bool get canRedo => _undoneActions.isNotEmpty;

  /// Ajoute une nouvelle action
  void pushAction(UndoableAction action) {
    _actions.add(action);
    _undoneActions.clear(); // Effacer les actions annulées
    
    if (_actions.length > maxActions) {
      _actions.removeAt(0);
    }
    
    notifyListeners();
  }

  /// Annule la dernière action
  MapState undo(MapState currentState) {
    if (!canUndo) return currentState;
    
    final action = _actions.removeLast();
    _undoneActions.add(action);
    
    notifyListeners();
    return action.undo(currentState);
  }

  /// Rétablit la dernière action annulée
  MapState redo(MapState currentState) {
    if (!canRedo) return currentState;
    
    final action = _undoneActions.removeLast();
    _actions.add(action);
    
    notifyListeners();
    return action.apply(currentState);
  }

  /// Efface l'historique
  void clear() {
    _actions.clear();
    _undoneActions.clear();
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
  MapState apply(MapState state) {
    return state.updateSymbol(symbolId, newSymbol);
  }

  @override
  MapState undo(MapState state) {
    return state.updateSymbol(symbolId, oldSymbol);
  }
}

/// Action pour ajouter un calque
class AddLayerAction implements UndoableAction {
  final Layer layer;

  AddLayerAction(this.layer);

  @override
  String get description => 'Ajouter calque';

  @override
  MapState apply(MapState state) {
    return state.copyWith(
      layers: [...state.layers, layer],
      selectedLayerIndex: state.layers.length,
    );
  }

  @override
  MapState undo(MapState state) {
    return state.removeLayer(layer.id);
  }
}

/// Action pour supprimer un calque
class RemoveLayerAction implements UndoableAction {
  final String layerId;
  final Layer layer;
  final int layerIndex;

  RemoveLayerAction(this.layerId, this.layer, this.layerIndex);

  @override
  String get description => 'Supprimer calque';

  @override
  MapState apply(MapState state) {
    return state.removeLayer(layerId);
  }

  @override
  MapState undo(MapState state) {
    final newLayers = List<Layer>.from(state.layers);
    newLayers.insert(layerIndex, layer);
    return state.copyWith(
      layers: newLayers,
      selectedLayerIndex: layerIndex,
    );
  }
}
