#!/bin/bash
set -e

# Определяем архитектуру
ARCH=$(uname -m)
echo "🔍 Обнаружена архитектура: $ARCH"

# Выбираем подходящий образ
if [[ "$ARCH" == "arm64" ]] || [[ "$ARCH" == "aarch64" ]]; then
    # Для Apple Silicon и других ARM64
    IMAGE="zydou/texlive:latest"
    echo "✅ Используем ARM-совместимый образ: $IMAGE"
else
    # Для Intel-совместимых процессоров
    IMAGE="ghcr.io/xu-cheng/texlive-full:20250301"
    echo "✅ Используем образ для x86_64: $IMAGE"
fi

WATCH_MODE=false

# Разбор аргументов
if [[ "$1" == "--watch" ]]; then
    WATCH_MODE=true
    echo "👀 Режим наблюдения включён. Контейнер будет работать до нажатия Ctrl+C."
fi

# Проверка Docker
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker не запущен или не установлен."
    echo "   Пожалуйста, убедитесь, что Docker установлен и запущен."
    exit 1
fi

echo "📥 Загрузка образа $IMAGE (если ещё не загружен)..."
docker pull "$IMAGE"

if [ "$WATCH_MODE" = true ]; then
    echo "🔄 Запуск непрерывной компиляции. Редактируйте файлы – PDF будет обновляться автоматически."
    docker run --rm \
        -v "$(pwd):/workspace" \
        -w /workspace \
        "$IMAGE" \
        latexmk -pdf -pvc -file-line-error -halt-on-error main.tex
else
    echo "🔨 Однократная компиляция main.tex..."
    docker run --rm \
        -v "$(pwd):/workspace" \
        -w /workspace \
        "$IMAGE" \
        latexmk -pdf -file-line-error -halt-on-error main.tex

    if [ $? -eq 0 ]; then
        echo "✅ Готово! PDF создан: $(pwd)/main.pdf"
    else
        echo "❌ Ошибка компиляции. Проверьте логи выше."
        exit 1
    fi
fi