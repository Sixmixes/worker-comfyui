#!/bin/bash
# This file will be sourced in init.sh
# Namespace functions with provisioning_

# Needed for CivitAI
CIVITAI_TOKEN="f18ace8f87913aba4486da9f9918fe49"

# Model paths
CHECKPOINT_DIR=/opt/ComfyUI/models/checkpoints
LORA_DIR=/opt/ComfyUI/models/loras
IPADAPTER_DIR=/opt/ComfyUI/models/ipadapter
CLIP_VISION_DIR=/opt/ComfyUI/models/clip_vision
CONTROLNET_DIR=/opt/ComfyUI/models/controlnet
NODES_DIR=/opt/ComfyUI/custom_nodes

function provisioning_start() {
    echo "=========================================="
    echo "STARTING ZERO-NETWORK-VOLUME PROVISIONING"
    echo "=========================================="

    # 1. Custom Nodes
    echo "Downloading Custom Nodes..."
    cd $NODES_DIR
    git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
    git clone https://github.com/pythongosssss/ComfyUI-WD14-Tagger.git
    git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux.git

    # Install Python Requirements for the nodes
    cd /opt/ComfyUI
    source /opt/environments/python/comfyui/bin/activate
    pip install -r $NODES_DIR/ComfyUI-WD14-Tagger/requirements.txt
    pip install -r $NODES_DIR/comfyui_controlnet_aux/requirements.txt
    pip install -r $NODES_DIR/ComfyUI_IPAdapter_plus/requirements.txt

    # 2. Base Directories Make Sure They Exist
    mkdir -p $CHECKPOINT_DIR $LORA_DIR $IPADAPTER_DIR $CLIP_VISION_DIR $CONTROLNET_DIR

    # 3. Download Models
    echo "Downloading SDXL Models..."
    wget -q --show-progress -O $IPADAPTER_DIR/ip-adapter-plus_sdxl_vit-h.safetensors "https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter-plus_sdxl_vit-h.safetensors"
    
    wget -q --show-progress -O $CLIP_VISION_DIR/CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors "https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors"
    
    wget -q --show-progress -O $CONTROLNET_DIR/diffusion_pytorch_model.safetensors "https://huggingface.co/diffusers/controlnet-depth-sdxl-1.0/resolve/main/diffusion_pytorch_model.safetensors"
    
    wget -q --show-progress -O $CHECKPOINT_DIR/Juggernaut_XL.safetensors "https://huggingface.co/RunDiffusion/Juggernaut-XL-v9/resolve/main/Juggernaut-XL_v9_RunDiffusionPhoto_v2.safetensors"

    echo "Downloading LoRAs..."
    wget -q --show-progress --header="Authorization: Bearer $CIVITAI_TOKEN" -O $LORA_DIR/Selfie_FefaAIart.safetensors "https://civitai.com/api/download/models/332520?type=Model&format=SafeTensor"
    
    wget -q --show-progress -O $LORA_DIR/add-detail-xl.safetensors "https://huggingface.co/LyliaEngine/add-detail-xl/resolve/main/add-detail-xl.safetensors"

    echo "=========================================="
    echo "PROVISIONING COMPLETE. BOOTING COMFYUI..."
    echo "=========================================="
}

provisioning_start
