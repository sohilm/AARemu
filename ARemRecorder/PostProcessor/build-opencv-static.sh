BASE="/ssd"
DIR=$BASE"/opencv"
BUILD="build.static"
TARGET="/opt/opencv-static"
#CUDADIR="/opt/cuda"
#CUDA_ARCH="3.0"
CUDA_FLAGS="--compiler-bindir /usr/bin/gcc-5"

if [ $# -gt 0 ] && [ $1 = "init" ]
then
   cd $BASE
   git clone https://github.com/Itseez/opencv.git
   cd $DIR
   git clone https://github.com/Itseez/opencv_contrib.git
fi

cd $DIR
git pull
cd opencv_contrib
git pull
cd ..
rm -rf $BUILD CMakeCache.txt CMakeFiles/ CMakeVars.txt
mkdir $BUILD
cd $BUILD
cmake -GNinja -DWITH_MATLAB=NO -DENABLE_PRECOMPILED_HEADERS=OFF -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON -DBUILD_EXAMPLES=NO -DBUILD_ANDROID_EXAMPLES=NO -DINSTALL_PYTHON_EXAMPLES=NO -DBUILD_TESTS=OFF -DWITH_OPENCL=YES -DWITH_CUDA=YES -DCUDA_NVCC_FLAGS="$CUDA_FLAGS" -DWITH_EIGEN=YES -DWITH_IPP=YES  -DOPENCV_EXTRA_MODULES_PATH="$DIR/opencv_contrib/modules" -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX="$TARGET" -DWITH_QT=NO -DWITH_OPENGL=NO -DBUILD_opencv_dnn=NO -DBUILD_opencv_hdf=NO -DBUILD_SHARED_LIBS=OFF "$DIR"
if [ $? -eq 0 ]
then
   rm -rf "$TARGET"
   ninja install/strip
fi
