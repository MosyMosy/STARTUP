import torch
import copy
import models
from collections import OrderedDict


def load_checkpoint(model, load_path, device):
    '''
    Load model and optimizer from load path 
    Return the epoch to continue the checkpoint
    '''
    state = torch.load(load_path, map_location=torch.device(device))['state']
    clf_state = OrderedDict()
    state_keys = list(state.keys())
    for _, key in enumerate(state_keys):
        if "feature." in key:
            # an architecture model has attribute 'feature', load architecture
            # feature to backbone by casting name from 'feature.trunk.xx' to 'trunk.xx'
            newkey = key.replace("feature.", "")
            state[newkey] = state.pop(key)
        elif "classifier." in key:
            newkey = key.replace("classifier.", "")
            clf_state[newkey] = state.pop(key)
        else:
            state.pop(key)
    model.load_state_dict(state)
    model.eval()
    return model


def checkpoint(model, save_path):
    '''
    epoch: the number of epochs of training that has been done
    Should resume from epoch
    '''
    sd = {
        'model': copy.deepcopy(model.state_dict())
    }

    torch.save(sd, save_path)
    return sd


checkpoint(load_checkpoint(models.ResNet10(
), "teacher_miniImageNet_na/logs_deterministic/checkpoints/miniImageNet/ResNet10_baseline_256_aug/399.tar", torch.device("cpu")), "baseline_na_teacher/checkpoint_best.pkl")
