#!/bin/bash

# DeepAgents LangGraph 应用停止脚本

set -e

echo "🛑 停止 DeepAgents LangGraph 应用..."

# 检查 Docker 和 Docker Compose 是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装，请先安装 Docker"
    exit 1
fi

if ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose 未安装，请先安装 Docker Compose"
    exit 1
fi

# 检查是否有运行中的服务
if ! docker compose ps | grep -q "Up"; then
    echo "ℹ️  没有运行中的服务"
    exit 0
fi

# 解析命令行参数
CLEAN_VOLUMES=false
CLEAN_IMAGES=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --volumes|-v)
            CLEAN_VOLUMES=true
            shift
            ;;
        --images|-i)
            CLEAN_IMAGES=true
            shift
            ;;
        --all|-a)
            CLEAN_VOLUMES=true
            CLEAN_IMAGES=true
            shift
            ;;
        *)
            echo "❌ 未知参数: $1"
            echo "用法: $0 [--volumes|-v] [--images|-i] [--all|-a]"
            echo "  --volumes, -v: 同时移除数据卷"
            echo "  --images, -i:  同时移除镜像"
            echo "  --all, -a:     移除所有（卷和镜像）"
            exit 1
            ;;
    esac
done

# 显示当前运行的服务
echo "📊 当前运行的服务："
docker compose ps

# 停止服务
echo ""
echo "🛑 正在停止服务..."
if [ "$CLEAN_VOLUMES" = true ]; then
    docker compose down -v
    echo "🗑️  已移除数据卷"
else
    docker compose down
fi

# 移除镜像（如果指定）
if [ "$CLEAN_IMAGES" = true ]; then
    echo "🗑️  正在移除镜像..."
    docker compose down --rmi local
    echo "🗑️  已移除本地镜像"
fi

echo ""
echo "✅ DeepAgents LangGraph 应用已停止！"
echo ""
echo "💡 提示："
echo "   - 使用 ./start.sh 重新启动服务"
if [ "$CLEAN_VOLUMES" = false ]; then
    echo "   - 使用 ./stop.sh --volumes 可以移除数据卷"
fi
if [ "$CLEAN_IMAGES" = false ]; then
    echo "   - 使用 ./stop.sh --images 可以移除镜像"
    echo "   - 使用 ./stop.sh --all 可以完全清理（卷和镜像）"
fi

