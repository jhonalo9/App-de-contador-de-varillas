# python_detector.py
import sys
import json
import os
from inference_sdk import InferenceHTTPClient

# Configuración fija
API_KEY = "0XKzAOYpN62OTpgqoPQo"
WORKSPACE = "jelrs-workspace"
WORKFLOW_ID = "general-segmentation-api-4"

# Inicializar cliente (una sola vez para mejor rendimiento)
client = InferenceHTTPClient(
    api_url="https://serverless.roboflow.com",
    api_key=API_KEY
)

def detect_steel_bars(image_path):
    """Detecta varillas de acero en una imagen"""
    try:
        result = client.run_workflow(
            workspace_name=WORKSPACE,
            workflow_id=WORKFLOW_ID,
            images={"image": image_path},
            parameters={"classes": "steel"},
            use_cache=True
        )
        
        # Contar detecciones
        count = 0
        if result and len(result) > 0:
            predictions = result[0]["predictions"]["predictions"]
            count = len(predictions)
        
        return {"success": True, "count": count}
        
    except Exception as e:
        return {"success": False, "error": str(e), "count": 0}

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(json.dumps({"success": False, "error": "No image path provided", "count": 0}))
        sys.exit(1)
    
    image_path = sys.argv[1]
    result = detect_steel_bars(image_path)
    print(json.dumps(result))