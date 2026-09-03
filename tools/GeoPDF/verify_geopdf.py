#!/usr/bin/env python3
"""
Script de vérification pour les GeoPDF.

Ce script permet de :
1. Vérifier que les dépendances (Poppler, GDAL) sont installées.
2. Tester la lecture d'un GeoPDF et afficher ses métadonnées.
3. Vérifier le géoréférencement (Viewport GEO).

Utilisation :
    python verify_geopdf.py --check-dependencies
    python verify_geopdf.py --test-file <chemin_vers_pdf>
"""

import argparse
import sys
import os
import subprocess
import re
from typing import Dict, List, Optional, Tuple


# ============================================================================
# Fonctions de vérification des dépendances
# ============================================================================

def check_poppler() -> bool:
    """Vérifie si Poppler est installé et accessible."""
    try:
        # Vérifier pdfinfo (outil en ligne de commande de Poppler)
        result = subprocess.run(
            ["pdfinfo", "--version"],
            capture_output=True,
            text=True
        )
        if result.returncode == 0 and "poppler" in result.stdout.lower():
            print("✅ Poppler (pdfinfo) est installé")
            return True
        
        # Vérifier la librairie Poppler (pour le développement)
        result = subprocess.run(
            ["pkg-config", "--modversion", "poppler"],
            capture_output=True,
            text=True
        )
        if result.returncode == 0:
            print(f"✅ Poppler (librairie) est installé (version: {result.stdout.strip()})")
            return True
        
        print("❌ Poppler n'est pas installé ou n'est pas dans le PATH")
        return False
    except FileNotFoundError:
        print("❌ Poppler n'est pas installé")
        return False


def check_gdal() -> bool:
    """Vérifie si GDAL est installé et accessible."""
    try:
        result = subprocess.run(
            ["gdalinfo", "--version"],
            capture_output=True,
            text=True
        )
        if result.returncode == 0:
            version_match = re.search(r'GDAL (\d+\.\d+\.\d+)', result.stdout)
            if version_match:
                print(f"✅ GDAL est installé (version: {version_match.group(1)})")
            else:
                print("✅ GDAL est installé")
            return True
        
        # Vérifier avec gdal-config
        result = subprocess.run(
            ["gdal-config", "--version"],
            capture_output=True,
            text=True
        )
        if result.returncode == 0:
            print(f"✅ GDAL est installé (version: {result.stdout.strip()})")
            return True
        
        print("❌ GDAL n'est pas installé ou n'est pas dans le PATH")
        return False
    except FileNotFoundError:
        print("❌ GDAL n'est pas installé")
        return False


def check_python_packages() -> bool:
    """Vérifie si les packages Python nécessaires sont installés."""
    required_packages = [
        "PyPDF2",
        "pdfminer.six",
        "pypdf",
        "Pillow",
    ]
    
    all_ok = True
    for package in required_packages:
        try:
            __import__(package.replace(".", "_"))
            print(f"✅ Package Python '{package}' est installé")
        except ImportError:
            print(f"❌ Package Python '{package}' n'est pas installé")
            all_ok = False
    
    return all_ok


def check_dependencies() -> bool:
    """Vérifie toutes les dépendances nécessaires."""
    print("Vérification des dépendances pour GeoPDF...\n")
    
    deps_ok = True
    
    print("=== Dépendances système ===")
    if not check_poppler():
        deps_ok = False
    if not check_gdal():
        deps_ok = False
    
    print("\n=== Dépendances Python ===")
    if not check_python_packages():
        deps_ok = False
    
    print("\n" + "="*50)
    if deps_ok:
        print("✅ Toutes les dépendances sont installées !")
    else:
        print("❌ Certaines dépendances manquent. Voir ci-dessus pour les installer.")
    print("="*50)
    
    return deps_ok


# ============================================================================
# Fonctions pour lire un GeoPDF
# ============================================================================

def extract_metadata_with_pypdf(pdf_path: str) -> Dict[str, str]:
    """Extraire les métadonnées d'un PDF avec PyPDF2."""
    try:
        from PyPDF2 import PdfReader
        
        with open(pdf_path, 'rb') as f:
            reader = PdfReader(f)
            metadata = reader.metadata or {}
            
            return {k: str(v) for k, v in metadata.items()}
    except ImportError:
        print("⚠️  PyPDF2 non disponible. Essai avec pdfminer...")
        return {}
    except Exception as e:
        print(f"⚠️  Erreur avec PyPDF2: {e}")
        return {}


def extract_metadata_with_pdfminer(pdf_path: str) -> Dict[str, str]:
    """Extraire les métadonnées d'un PDF avec pdfminer.six."""
    try:
        from pdfminer.high_level import extract_docs
        from pdfminer.pdfparser import PDFParser
        from pdfminer.pdfdocument import PDFDocument
        
        metadata = {}
        
        with open(pdf_path, 'rb') as f:
            parser = PDFParser(f)
            doc = PDFDocument(parser)
            
            if doc.info:
                for key, value in doc.info[0].items():
                    metadata[key] = str(value)
        
        return metadata
    except ImportError:
        print("⚠️  pdfminer.six non disponible.")
        return {}
    except Exception as e:
        print(f"⚠️  Erreur avec pdfminer: {e}")
        return {}


def extract_metadata(pdf_path: str) -> Dict[str, str]:
    """Extraire les métadonnées d'un PDF (toutes méthodes confondues)."""
    metadata = extract_metadata_with_pypdf(pdf_path)
    if not metadata:
        metadata = extract_metadata_with_pdfminer(pdf_path)
    
    return metadata


def extract_georeferencing_with_poppler(pdf_path: str) -> Optional[Dict[str, any]]:
    """Extraire le géoréférencement avec l'outil pdfinfo de Poppler."""
    try:
        result = subprocess.run(
            ["pdfinfo", "-js", pdf_path],
            capture_output=True,
            text=True
        )
        
        if result.returncode != 0:
            return None
        
        # Parser le JSON de sortie
        import json
        data = json.loads(result.stdout)
        
        # Vérifier si des données de géoréférencement sont présentes
        if "Pages" in data and len(data["Pages"]) > 0:
            page = data["Pages"][0]
            if "Viewport" in page and "Measure" in page["Viewport"]:
                measure = page["Viewport"]["Measure"]
                return {
                    "crs": measure.get("GCS", {}).get("EPSG", "Unknown"),
                    "gpts": measure.get("GPTS", []),
                    "lpts": measure.get("LPTS", []),
                    "bounds": calculate_bounds(measure.get("GPTS", [])),
                }
        
        return None
    except Exception as e:
        print(f"⚠️  Erreur avec pdfinfo: {e}")
        return None


def extract_georeferencing_with_gdal(pdf_path: str) -> Optional[Dict[str, any]]:
    """Extraire le géoréférencement avec GDAL."""
    try:
        result = subprocess.run(
            ["gdalinfo", "-json", pdf_path],
            capture_output=True,
            text=True
        )
        
        if result.returncode != 0:
            return None
        
        import json
        data = json.loads(result.stdout)
        
        if "geoTransform" in data:
            transform = data["geoTransform"]
            return {
                "crs": data.get("coordinateSystem", {}).get("wkt", "Unknown"),
                "transform": transform,
                "bounds": [
                    transform[0],
                    transform[3] + data["size"][1] * transform[5],
                    transform[0] + data["size"][0] * transform[1],
                    transform[3]
                ],
            }
        
        return None
    except Exception as e:
        print(f"⚠️  Erreur avec gdalinfo: {e}")
        return None


def calculate_bounds(gpts: List[float]) -> List[float]:
    """Calcule les bounds géographiques à partir des GPTS."""
    if len(gpts) < 8:
        return []
    
    lons = [gpts[i] for i in [0, 2, 4, 6]]
    lats = [gpts[i] for i in [1, 3, 5, 7]]
    
    return [
        min(lons), min(lats),
        max(lons), max(lats)
    ]


def extract_georeferencing(pdf_path: str) -> Optional[Dict[str, any]]:
    """Extraire le géoréférencement d'un PDF (toutes méthodes confondues)."""
    georef = extract_georeferencing_with_poppler(pdf_path)
    if not georef:
        georef = extract_georeferencing_with_gdal(pdf_path)
    
    return georef


def parse_pdf_date(pdf_date: str) -> Optional[str]:
    """Parse une date au format PDF (D:YYYYMMDDHHmmSS+HH'MM')."""
    match = re.match(r'D:(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})', pdf_date)
    if match:
        return f"{match.group(1)}-{match.group(2)}-{match.group(3)} {match.group(4)}:{match.group(5)}:{match.group(6)}"
    return None


def parse_url_parameters(url: str) -> Dict[str, str]:
    """Parse les paramètres d'une URL OpenOrienteeringMap."""
    from urllib.parse import urlparse, parse_qs
    
    params = {}
    try:
        parsed = urlparse(url)
        if parsed.query:
            params.update(parse_qs(parsed.query, keep_blank_values=True))
    except Exception:
        pass
    
    return {k: str(v[0]) if isinstance(v, list) else str(v) for k, v in params.items()}


# ============================================================================
# Fonction principale de test
# ============================================================================

def test_geopdf(pdf_path: str) -> bool:
    """Teste la lecture d'un GeoPDF et affiche ses informations."""
    if not os.path.exists(pdf_path):
        print(f"❌ Fichier non trouvé: {pdf_path}")
        return False
    
    print(f"\nAnalyse du fichier: {pdf_path}\n")
    print("="*60)
    
    # Extraire les métadonnées
    print("\n📋 Métadonnées:")
    print("-"*60)
    metadata = extract_metadata(pdf_path)
    
    if not metadata:
        print("⚠️  Aucune métadonnée trouvée.")
    else:
        for key, value in metadata.items():
            # Parser la date
            if key == "/CreationDate":
                parsed_date = parse_pdf_date(value)
                if parsed_date:
                    value = parsed_date
            # Parser l'URL pour extraire les paramètres
            elif key == "/URL" and "oomap.dna-software.co.uk" in value:
                url_params = parse_url_parameters(value)
                print(f"  {key}: {value}")
                print("\n  Paramètres de l'URL:")
                for param, param_value in url_params.items():
                    print(f"    - {param}: {param_value}")
                continue
            
            print(f"  {key}: {value}")
    
    # Extraire le géoréférencement
    print("\n🌍 Géoréférencement:")
    print("-"*60)
    georef = extract_georeferencing(pdf_path)
    
    if not georef:
        print("⚠️  Aucune donnée de géoréférencement trouvée.")
        print("   Ce fichier n'est peut-être pas un GeoPDF.")
    else:
        print(f"  CRS: {georef.get('crs', 'Inconnu')}")
        
        if "bounds" in georef:
            bounds = georef["bounds"]
            if len(bounds) >= 4:
                print(f"  Bounds: [Lon: {bounds[0]:.6f} à {bounds[2]:.6f}, Lat: {bounds[1]:.6f} à {bounds[3]:.6f}]")
                center_lon = (bounds[0] + bounds[2]) / 2
                center_lat = (bounds[1] + bounds[3]) / 2
                print(f"  Centre: {center_lat:.6f}°N, {center_lon:.6f}°E")
        
        if "gpts" in georef and georef["gpts"]:
            gpts = georef["gpts"]
            print(f"  GPTS (coordonnées géographiques): {gpts}")
        
        if "lpts" in georef and georef["lpts"]:
            lpts = georef["lpts"]
            print(f"  LPTS (coordonnées locales): {lpts}")
        
        if "transform" in georef:
            transform = georef["transform"]
            print(f"  Transformation GDAL: {transform}")
    
    # Vérifier si c'est un GeoPDF OpenOrienteeringMap
    if metadata.get("/Producer", "").lower().find("openorienteeringmap") != -1:
        print("\n✅ Ce fichier est un GeoPDF généré par OpenOrienteeringMap.")
        print("   Il peut être importé directement dans OWildZimut.")
    else:
        print("\n⚠️  Ce fichier ne semble pas être un GeoPDF OpenOrienteeringMap.")
        print("   L'import peut nécessiter une calibration manuelle.")
    
    print("\n" + "="*60)
    return True


# ============================================================================
# Point d'entrée
# ============================================================================

def main():
    parser = argparse.ArgumentParser(
        description="Script de vérification pour les GeoPDF - OWildZimut",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemples d'utilisation:
  python verify_geopdf.py --check-dependencies
  python verify_geopdf.py --test-file assets/oomWeb/oom_Villerest.pdf
        """
    )
    
    parser.add_argument(
        "--check-dependencies",
        action="store_true",
        help="Vérifie que toutes les dépendances sont installées"
    )
    parser.add_argument(
        "--test-file",
        type=str,
        help="Teste la lecture d'un fichier GeoPDF"
    )
    parser.add_argument(
        "--version",
        action="version",
        version="%(prog)s 1.0.0"
    )
    
    args = parser.parse_args()
    
    if not args.check_dependencies and not args.test_file:
        parser.print_help()
        sys.exit(1)
    
    if args.check_dependencies:
        success = check_dependencies()
        sys.exit(0 if success else 1)
    
    if args.test_file:
        success = test_geopdf(args.test_file)
        sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
