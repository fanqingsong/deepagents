from langchain_openai import AzureChatOpenAI
import os


def get_default_model():
    """获取默认的 Azure OpenAI 模型"""
    return AzureChatOpenAI(
        azure_deployment=os.getenv("AZURE_OPENAI_DEPLOYMENT_NAME", "gpt-4"),
        azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT"),
        api_key=os.getenv("AZURE_OPENAI_API_KEY"),
        api_version=os.getenv("AZURE_OPENAI_API_VERSION", "2024-02-15-preview"),
        model_name=os.getenv("AZURE_OPENAI_MODEL_NAME", "gpt-4"),
        max_tokens=4000,
        temperature=0.7
    )
