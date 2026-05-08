#!/usr/bin/env bash
set -euo pipefail

echo "==> Updating apt packages"
sudo apt update

echo "==> Installing required system packages"
sudo apt install -y \
  python3.10 \
  python3.10-venv \
  python3-pip \
  build-essential \
  git \
  curl

WORKDIR="$HOME/tf-kerasnlp"
VENV_DIR="$WORKDIR/.venv"

echo "==> Creating workdir: $WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

echo "==> Creating virtual environment"
python3.10 -m venv "$VENV_DIR"

echo "==> Activating virtual environment"
source "$VENV_DIR/bin/activate"

echo "==> Upgrading pip/setuptools/wheel"
python -m pip install --upgrade pip setuptools wheel

echo "==> Installing TensorFlow stack"
pip install \
  "tensorflow==2.15.*" \
  "tensorflow-text==2.15.*" \
  "keras-nlp"

echo "==> Writing verification script"
cat > verify_install.py << 'PY'
import tensorflow as tf
import tensorflow_text as tf_text
import keras_nlp

print("TensorFlow version:", tf.__version__)
print("tensorflow_text imported successfully")
print("keras_nlp imported successfully")

classifier = keras_nlp.models.BertClassifier.from_preset(
    "bert_tiny_en_uncased",
    num_classes=2
)
print("BertClassifier loaded successfully")
PY

echo "==> Running verification"
python verify_install.py

echo "==> Done"
echo "To reuse later:"
echo "cd $WORKDIR && source $VENV_DIR/bin/activate"