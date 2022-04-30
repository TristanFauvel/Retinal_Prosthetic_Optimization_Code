from pulse2percept.implants import ArgusII, PRIMA
from pulse2percept.models import AxonMapSpatial
import numpy as np

rho = 200
axlambda = 400
x = 0
y = 0
z = -100
rot = 0
eye = 'RE'
xrange = (-18, 16)
yrange = (-11, 11)
xystep = 0.5
n_ax_segments=300
n_axons=400
ignore_pickle = True
implant_name = 'Argus II'

xrange = (-9, 8)
yrange = (-6, 6)
from pulse2percept.viz import plot_implant_on_axon_map, plot_axon_map
import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('Qt5Agg')

if implant_name == 'Argus II':
    implant = ArgusII( x=x, y=y, z=z, rot=rot, eye=eye)   
          
    implant.stim={'A8': 30}
    nelectrodes = 60

elif implant_name == 'PRIMA':
    implant = PRIMA( x=x, y=y, z=z, rot=rot, eye=eye)   
    
    implant.stim={'A8': 30}
    nelectrodes = 378


#Without misspecification
beta_sup=-1.3 #-2.5,-1.3
beta_inf=1.3 #0.1 or 1,3


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
  
#plot_axon_map(eye='RE', loc_od=(15.5, 1.5), n_bundles=100, ax=None,upside_down=False, annotate=False, xlim=None, ylim=None)
model.plot(use_dva=False, annotate=False, autoscale=True, ax=None)
    
plt.savefig('figures_folder/correct_model.jpg', dpi = 300)  
plt.close('all')
#With misspecification
beta_sup=-2.5 #-2.5,-1.3
beta_inf=0.1 #0.1 or 1,3

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
  
#plot_axon_map(eye='RE', loc_od=(15.5, 1.5), n_bundles=100, ax=None,upside_down=False, annotate=False, xlim=None, ylim=None)
model.plot(use_dva=False, annotate=False, autoscale=True, ax=None)
plt.savefig('figures_folder/misspecified_model.jpg', dpi = 300)  

  
    
# plot_implant_on_axon_map(implant, loc_od=(15.5, 1.5), n_bundles=100,ax=None, upside_down=False, annotate_implant=False, annotate_quadrants=False)
# plt.savefig('figures_folder/correct_model')



# percept = model.predict_percept(implant)
# percept.data = percept.data/percept.data.max()
# ax = percept.plot()
# ax.set_title('Predicted percept')

#plt.imshow(9.1*percept.data[:,:])
# percept.data.max()
#plot_axon_map(eye='RE', loc_od=(15.5, 1.5), n_bundles=100, ax=None, upside_down=False, beta_sup = beta_sup, beta_inf = beta_inf)
#plt.savefig('/media/sf_Documents/Retinal_prosthetic_optimization/drawing_misspecification')
plt.savefig('figures_folder/correct_model')