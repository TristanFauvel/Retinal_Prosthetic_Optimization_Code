from pulse2percept.implants import ArgusII, PRIMA
from pulse2percept.models import AxonMapSpatial
import numpy as np

def Compute_perceptual_model(rho = 200, axlambda= 400, x = 0, y = 0, z = 0, rot = 0, eye = 'RE', xrange = (-18, 16), yrange = (-11, 11), xystep = 0.5, n_ax_segments=300, n_axons=200, beta_sup=-1.9, beta_inf=0.5, ignore_pickle = True, implant_name= 'Argus II'): 
# Compute_perceptual_model(rho = 200, axlambda= 400, x = 0, y = 0, z = 0, rot = 0, eye = 'RE', xrange = (-18, 16), yrange = (-11, 11), xystep = 0.5, n_ax_segments=300, n_axons=400, beta_sup=-1.9, beta_inf=0.5, ignore_pickle = True, implant_name= 'Argus II'): 
  
    if implant_name == 'Argus II':
        implant = ArgusII( x=x, y=y, z=z, rot=rot, eye=eye)   
      
        implant.stim={'A8': 30}
        nelectrodes = 60
        
    elif implant_name == 'PRIMA':
          implant = PRIMA( x=x, y=y, z=z, rot=rot, eye=eye)   
      
          implant.stim={'A8': 30}
          nelectrodes = 378
        
    model = AxonMapSpatial(ax_segments_range=(3, 50), axlambda=axlambda, 
                      axon_pickle='axons.pickle', 
                      axons_range=(-180, 180), engine='serial', 
                      eye='RE', grid_type='rectangular', 
                      ignore_pickle=ignore_pickle, n_ax_segments=n_ax_segments, 
                      n_axons=n_axons, n_jobs=1, rho=rho, 
                      scheduler='threading', thresh_percept=0, 
                      verbose=True, xrange=xrange, xystep=xystep, 
                      yrange=yrange,beta_sup=beta_sup, beta_inf=beta_inf)
    model.build()
      
    percept = model.predict_percept(implant)
    
    perceptual_model = np.zeros((percept.shape[0], percept.shape[1], nelectrodes))
    k=0
    for name, electrode in implant.items():
        implant.stim={name: 30}
        percept = model.predict_percept(implant)
        perceptual_model[:,:,k] = percept.data.squeeze()
        k=k+1
    
    return perceptual_model


# rho = 200
# axlambda = 400
# x = 0
# y = 0
# z = -100
# rot = 0
# eye = 'RE'
# xrange = (-18, 16)
# yrange = (-11, 11)
# xystep = 0.5
# n_ax_segments=300
# n_axons=400
# ignore_pickle = True
# implant_name = 'Argus II'
# beta_sup=-1.9
# beta_inf=0.5
# beta_sup=4.9
# beta_inf=1.5
# xrange = (-9, 8)
# yrange = (-6, 6)
# from pulse2percept.viz import plot_implant_on_axon_map, plot_axon_map
# import matplotlib.pyplot as plt
# import matplotlib
# matplotlib.use('Qt5Agg')

# if implant_name == 'Argus II':
#     implant = ArgusII( x=x, y=y, z=z, rot=rot, eye=eye)   
          
#     implant.stim={'A8': 30}
#     nelectrodes = 60

# elif implant_name == 'PRIMA':
#     implant = PRIMA( x=x, y=y, z=z, rot=rot, eye=eye)   
    
#     implant.stim={'A8': 30}
#     nelectrodes = 378

# model = AxonMapSpatial(ax_segments_range=(3, 50), axlambda=axlambda, 
#                   axon_pickle='axons.pickle', 
#                   axons_range=(-180, 180), engine='serial', 
#                   eye='RE', grid_type='rectangular', 
#                   ignore_pickle=ignore_pickle, n_ax_segments=n_ax_segments, 
#                   n_axons=n_axons, n_jobs=1, rho=rho, 
#                   scheduler='threading', thresh_percept=0, 
#                   verbose=True, xrange=xrange, xystep=xystep, 
#                   yrange=yrange,beta_sup=beta_sup, beta_inf=beta_inf)
# model.build()
  
# percept = model.predict_percept(implant)
# #plot_implant_on_axon_map(implant, loc_od=(15.5, 1.5), n_bundles=100,ax=None, upside_down=False, annotate_implant=False, annotate_quadrants=False, beta_sup=beta_sup, beta_inf=beta_inf)
# percept = model.predict_percept(implant)
# percept.data = percept.data/percept.data.max()
# ax = percept.plot()
# ax.set_title('Predicted percept')

# plt.imshow(9.1*percept.data[:,:])
# # percept.data.max()
# # plot_axon_map(eye='RE', loc_od=(15.5, 1.5), n_bundles=100, ax=None, upside_down=False, annotate_quadrants=False)