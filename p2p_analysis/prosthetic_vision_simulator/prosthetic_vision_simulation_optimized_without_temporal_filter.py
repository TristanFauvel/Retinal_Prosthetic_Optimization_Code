import numpy as np
import skimage.transform as sit
import cv2

implant_name='ArgusII'  
from core_pkg.define_ArgusII import percept_size, invert
cap = cv2.VideoCapture(0)
   
M=np.load(".//Data//"+implant_name+"//M.npy")

W=np.linalg.pinv(M)

max_input=np.ones(percept_size[0]*percept_size[1])
normalization_factor = np.max(abs(np.dot(M@W,max_input)))

invert=False
while(True):
    # Capture frame-by-frame
    ret, frame = cap.read()
    frame = cv2.cvtColor(frame,cv2.COLOR_BGR2RGB)
#    frame=np.array(mywin.getMovieFrame())
                        
#        pp.pattern_downsampling(electrodes, dwnspl_factor)
    gray_frame = cv2.cvtColor(frame, cv2.COLOR_RGB2GRAY) 
    
    model_input= sit.resize(gray_frame, percept_size)
    if invert:
        model_input=1.0-model_input
    model_input_reshaped=model_input.reshape(-1)
    predicted_percept=abs(np.dot(M@W,model_input_reshaped))
    predicted_percept=predicted_percept.reshape(percept_size)
#    normalization_factor=max(normalization_factor,np.max(predicted_percept))
    normalization_factor=np.max(predicted_percept)
    predicted_percept=predicted_percept*255/normalization_factor
    resized = cv2.resize(predicted_percept, (gray_frame.shape[1],gray_frame.shape[0]))
    # Display the resulting frame
    p2p_frame=resized.astype(np.uint8)
    
    final = cv2.hconcat([gray_frame, p2p_frame])
    
    cv2.imshow('frame',final)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# When everything done, release the capture
cap.release()
cv2.destroyAllWindows()

