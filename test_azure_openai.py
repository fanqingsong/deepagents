#!/usr/bin/env python3
"""
Azure OpenAI 配置测试脚本
"""

import os
import sys
from langchain_openai import AzureChatOpenAI
from deepagents import create_deep_agent

def test_azure_openai_config():
    """测试 Azure OpenAI 配置"""
    print("🔧 测试 Azure OpenAI 配置...")
    
    # 检查环境变量
    required_vars = [
        "AZURE_OPENAI_API_KEY",
        "AZURE_OPENAI_ENDPOINT", 
        "AZURE_OPENAI_DEPLOYMENT_NAME"
    ]
    
    missing_vars = []
    for var in required_vars:
        if not os.getenv(var):
            missing_vars.append(var)
    
    if missing_vars:
        print(f"❌ 缺少环境变量: {', '.join(missing_vars)}")
        print("请检查 .env 文件配置")
        return False
    
    print("✅ 环境变量配置正确")
    
    # 测试 Azure OpenAI 连接
    try:
        model = AzureChatOpenAI(
            azure_deployment=os.getenv("AZURE_OPENAI_DEPLOYMENT_NAME", "gpt-4"),
            azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT"),
            api_key=os.getenv("AZURE_OPENAI_API_KEY"),
            api_version=os.getenv("AZURE_OPENAI_API_VERSION", "2024-02-15-preview"),
            model_name=os.getenv("AZURE_OPENAI_MODEL_NAME", "gpt-4"),
            max_tokens=100,
            temperature=0.7
        )
        
        # 测试简单对话
        response = model.invoke("Hello, how are you?")
        print("✅ Azure OpenAI 连接成功")
        print(f"   响应: {response.content[:50]}...")
        
        return True
        
    except Exception as e:
        print(f"❌ Azure OpenAI 连接失败: {e}")
        return False

def test_deepagents_with_azure():
    """测试 DeepAgents 与 Azure OpenAI 集成"""
    print("\n🤖 测试 DeepAgents 与 Azure OpenAI 集成...")
    
    try:
        # 创建使用 Azure OpenAI 的 Agent
        agent = create_deep_agent(
            tools=[],
            instructions="你是一个智能助手，请用中文回答。",
            model="azure-gpt-4"  # 这会使用默认的 Azure OpenAI 配置
        )
        
        # 测试对话
        result = agent.invoke({
            "messages": [{"role": "user", "content": "你好，请简单介绍一下你自己"}]
        })
        
        print("✅ DeepAgents 与 Azure OpenAI 集成成功")
        if "messages" in result and result["messages"]:
            response = result["messages"][-1].content
            print(f"   响应: {response[:100]}...")
        
        return True
        
    except Exception as e:
        print(f"❌ DeepAgents 集成失败: {e}")
        return False

def main():
    """主测试函数"""
    print("🧪 Azure OpenAI 配置测试")
    print("=" * 50)
    
    # 加载环境变量
    from dotenv import load_dotenv
    load_dotenv()
    
    tests = [
        ("Azure OpenAI 配置", test_azure_openai_config),
        ("DeepAgents 集成", test_deepagents_with_azure),
    ]
    
    passed = 0
    total = len(tests)
    
    for test_name, test_func in tests:
        print(f"\n📝 {test_name}")
        print("-" * 30)
        if test_func():
            passed += 1
        else:
            print("❌ 测试失败")
    
    print("\n" + "=" * 50)
    print(f"📊 测试结果: {passed}/{total} 通过")
    
    if passed == total:
        print("🎉 所有测试通过！Azure OpenAI 配置正确")
        sys.exit(0)
    else:
        print("❌ 部分测试失败，请检查配置")
        sys.exit(1)

if __name__ == "__main__":
    main()
