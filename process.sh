echo Working with $1 file
echo Working with $2 model
echo Working with $3 rezult
echo Working with $4 texture

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#MLABSERVER = /Applications/meshlab.app/Contents/MacOS/meshlabserver
MLABSERVER = xvfb-run --auto-servernum meshlabserver

rm $DIR/tmp/in.obj #i know this fucking number must be 0!
rm $DIR/tmp/1.obj
rm $DIR/tmp/2.obj
rm $DIR/tmp/25.obj
rm $DIR/tmp/3.obj
rm $DIR/tmp/4.obj
rm $DIR/tmp/5.obj
rm $DIR/tmp/body.obj

cp $1 $DIR/tmp/in.obj
#cp $2 $DIR/tmp/body.obj
#cp $DIR/fixmesh.py $DIR/tmp/fixmesh.py


$DIR/obj-magic -o $DIR/tmp/1.obj  --center 0.0 --mirrory --scale 0.2  --normalize-normals $DIR/tmp/in.obj

#python $DIR/fix_rotate.py $DIR/tmp/1.obj 1

$MLABSERVER -i $DIR/tmp/1.obj -s $DIR/filter_file_fix_rotate.mlx  -o  $DIR/tmp/2.obj -m vc

$DIR/obj-magic -o $DIR/tmp/25.obj  --pScalex 12  --pScaley 18  --pScalez 24 $DIR/tmp/2.obj

$DIR/obj-magic -o $DIR/tmp/3.obj  --center 0.0  $DIR/tmp/25.obj

$MLABSERVER -i $DIR/tmp/3.obj -s $DIR/filter_file_fix_rotate2.mlx  -o  $DIR/tmp/3.obj -m vc

$DIR/obj-magic -o $DIR/tmp/4.obj --rotatex 1.57 --rotatez 1.57 --rotatey 3.14   $DIR/tmp/3.obj 

$DIR/obj-magic -o $DIR/tmp/5.obj   --rotatex 5.93412 --translatez 3.8 --translatey 1.3 $DIR/tmp/4.obj 

#docker run -v $DIR/tmp/:/var/3d/ -it qnzhou/pymesh python /var/3d/fixmesh.py

#python $DIR/reduce_faces.py $DIR/tmp/rezult.obj 1

#cp $DIR/tmp/union.obj $3



$MLABSERVER -i  $DIR/tmp/5.obj -s $DIR/skin.mlx 
convert $DIR/tmp/tex.png +dither -colors 1 $4 

$MLABSERVER -i $DIR/tmp/5.obj -i $2 -s $DIR/boolscript.mlx  -o  $DIR/tmp/temp1.obj -m vc -o  $DIR/tmp/temp2.obj -m vc -o  $DIR/tmp/union.obj -m vc

$MLABSERVER -i $DIR/tmp/5.obj -i  $DIR/tmp/union.obj -s $DIR/texture.mlx  -o  $DIR/tmp/temp1.obj -m vc  -o  $DIR/tmp/union.obj -m vc

$MLABSERVER -i $2 -i  $DIR/tmp/union.obj -s $DIR/texture2.mlx  -o  $DIR/tmp/temp1.obj -m vc  -o  $DIR/tmp/union.obj -m vc

$MLABSERVER -i  $DIR/tmp/union.obj -s $DIR/normalize.mlx  -o  $DIR/tmp/union.obj -m vc 


cp $DIR/tmp/union.obj $3

rm $DIR/tmp/temp1.obj
rm $DIR/tmp/temp2.obj

say model ready