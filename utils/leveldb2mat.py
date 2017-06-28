import leveldb
import feat_helper_pb2
import numpy as np
import scipy.io as sio
import time
import h5py

def main(argv):
    leveldb_name = sys.argv[1]
    print "%s" % sys.argv[1]
    num_img = int(sys.argv[2])
    dim_features = int(sys.argv[3])
    file_target = sys.argv[4]

    start = time.time()
    if 'db' not in locals().keys():
        db = leveldb.LevelDB(leveldb_name)
        datum = feat_helper_pb2.Datum()

    ft = np.zeros((num_img, dim_features))

    for im_idx in range(num_img):
        datum.ParseFromString(db.Get(str(im_idx).zfill(10)))
        ft[im_idx, :] = datum.float_data

    features_gallery = np.zeros((num_img / 2, dim_features * 2))
    features_gallery = np.concatenate((ft[0::2, :], ft[1::2, :]), axis = 1)

    print 'Time (Assigning Values): %f' %(time.time() - start)
        
    suffix = file_target[-3:];  

    if suffix == 'mat': # save in 'mat' format
        sio.savemat(file_target, {'features_gallery':features_gallery})
    else: # save in 'hdf5' format
        h5f = h5py.File(file_target, 'w')
        h5f.create_dataset('features_gallery', data = features_gallery)
        h5f.close()
        
    print 'Time (Writing to Disk): %f' %(time.time() - start)

    print 'done!'

        
    # leveldb.DestroyDB(leveldb_name)

if __name__ == '__main__':
    import sys
    main(sys.argv)
