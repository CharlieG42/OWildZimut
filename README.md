# OWildZimut

> Outil de creation de cartes de Course d'Orientation avec gestion avancee de calques

[![PySide6](https://img.shields.io/badge/PySide6-6.4+-green)](https://pypi.org/project/PySide6/)
[![Qt6](https://img.shields.io/badge/Qt-6.4+-blue)](https://www.qt.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## About

OWildZimut est un outil open-source pour creer et editer des cartes de Course d'Orientation (CO) avec une gestion avancee de calques.

---

## Quick Start

### Prerequisites
- Python 3.8+
- PySide6 6.4+
- Qt6

### Installation

git clone https://github.com/CharlieG42/OWildZimut.git
cd OWildZimut
python -m venv venv
source venv/bin/activate
pip install PySide6

### Run

python main.py

### With QtCreator

1. Open OWildZimut.pro in QtCreator
2. Configure Python kit
3. Run project

---

## Project Structure

OWildZimut/
- main.py - Entry point
- qml/ - QML files
  - main.qml - Main UI
  - LayerItem.qml - Layer list item
  - LayerRenderer.qml - Layer renderer
  - MapView.qml - Map view
- README.md
- requirements.txt
- .gitignore

---

## Features

### Layer Management
- Add/Remove layers
- Reorder with Up/Down buttons
- Toggle visibility
- Adjust opacity
- Lock/unlock

### Symbol Types (IOF)
- Point: Control posts (code 701)
- Line: Paths (code 502)
- Area: Forests (code 401)
- Text: Legends

---

## License

MIT License - see LICENSE file for details.

---

## Contact

- Author: Charlie Gentil
- Organization: WildZimut
- Repository: https://github.com/CharlieG42/OWildZimut