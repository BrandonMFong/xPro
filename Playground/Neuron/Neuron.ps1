# From https://towardsdatascience.com/lets-code-a-neural-network-in-plain-numpy-ae7e74410795

# NN_Architecture =
# @{
#     {"input_dim" = 2, "output_dim": 4, "activation": "relu"},
#     {"input_dim": 4, "output_dim": 6, "activation": "relu"},
#     {"input_dim": 6, "output_dim": 6, "activation": "relu"},
#     {"input_dim": 6, "output_dim": 4, "activation": "relu"},
#     {"input_dim": 4, "output_dim": 1, "activation": "sigmoid"}
# }

$NN_Architecture = 
@{
    "InputDimension" = 2, 4, 6, 6, 4;
    "OutputDimension" = 4, 6, 6, 4 , 1;     
    "Activation" = "relu", "relu", "relu", "relu", "sigmoid";
}

$Seed = 99;

function GetValues
{
    Param([int]$r, [int]$c)

    
}
function init_layers
{
    param($NN_Architecture, [int32]$Seed)

    $NumLayers = $NN_Architecture.Count;
    $ParamValues = @{};

    for($i=0;$i -lt $NumLayers;$i++)
    {
        for($l = 0;$l -lt $NumLayers;$l++)
        {
            $LayerIndex = $i + 1;
            $InputLayerSize = $NN_Architecuture.InputDimension.Count;
            $OutputLayerSize = $NN_Architecture.OutputDimension.Count;

            $ParamValues.Add($("W" + $LayerIndex.ToString()), $(GetValues -Row $InputLayerSize -Col $OutputLayerSize));
        }
    }
}