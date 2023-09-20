**Problem formulation**

You have to write a custom image recovery and texture identification program that can remove optical artefacts from an aerial image and can identify various land-types based on their appearance.

**Input:**  an image showing a distorted image captured by a drone **Output:**  a categorized (segmented) map of the captured landscape

Tasks to do

Write an algorithm that can process each captured image as follows:

1. loads the image and the corresponding GPS/IMU data
1. creates a custom motion kernel based on the recorded movements
1. uses an iterative deconvolution method (Richardson-Lucy)
1. applies local contrast enhancement (Wallis filter)
1. identifies the regions using a texture matching algorithm (Laws filter)
1. filters/enhances the result based on majority voting
1. returns a segmented image showing the clustered region map

Key results to be presented:

You may code freely, as there are not so many restrictions on what to use.

However, you should create a script which solves the exercise and presents the following outputs:

Figure 1 shows the “path” of the drone and the assumed PSF Figure 2 shows the degraded (original) and restored image Figure 3 shows the result of the Wallis filtering

Figure 4 shows the segmented terrain image


Figure 7

![](Aspose.Words.c3515584-f475-4445-a33b-06a21856d85b.001.jpeg)

![](Aspose.Words.c3515584-f475-4445-a33b-06a21856d85b.002.jpeg)


Figure 3

![](Aspose.Words.c3515584-f475-4445-a33b-06a21856d85b.003.jpeg)


Figure 4

9![](Aspose.Words.c3515584-f475-4445-a33b-06a21856d85b.004.jpeg)

There is no code package for this assignment.

All scripts and functions must be written entirely by you.

Download the image to be processed from here: <https://beta.dev.itk.ppke.hu/bipa/assignment_03>



Submission & hints

You should create a script named a03\_NEPTUN.m where the NEPTUN part is your Neptun ID. This has to be the main script; running that must be able to solve the problem. 

You are allowed to create other files (e.g. additional functions) too, if necessary. **Usage of any built-in high level restoration functions** (e.g. wallis, deconvlucy etc.) **is prohibited.**

Please submit ALL files (including the input folder as well) in a **ZIP** file via the Moodle system.

**Check the upcoming slides for hints!**


Hint 1

For each image there is a corresponding txt file containing the relative location coordinates of the drone during capturing.

The text file contains coordinates as a time series:

1     0     1     0     1     4     4     6     9    10     9    12    15    14   ... 1     3     5     6     9     9     8     8     8     7     9    10    12    11   ...![](Aspose.Words.c3515584-f475-4445-a33b-06a21856d85b.005.png)![](Aspose.Words.c3515584-f475-4445-a33b-06a21856d85b.006.png)

position at t=2

position at t=1


Hint 1

To create the assumed PSF copy (add) a Gaussian blur kernel to each point of the path. Use the following kernel:

k = fspecial('gaussian', 9, 1);

Do not forget to normalize the resulting kernel (sum must be 1).


Hint 2

The Richardson-Lucy reconstruction method is described in details in multiple articles [1,2]. The key idea is to apply the following iteration rule:

![](Aspose.Words.c3515584-f475-4445-a33b-06a21856d85b.007.png)

Where *d* is the degraded image, *u* is the reconstructed image and *P* is the PSF of the imaging system.

Also, it might be beneficial to read the following article: <https://en.wikipedia.org/wiki/Richardson%E2%80%93Lucy_deconvolution> 


Hint 3

There should be a stopping criteria for the iteration. It can be hard-coded or it can be based on some measures (e.g. the maximum pixel intensity in the result of the Laplacian-of-Gaussian filtering is above a threshold).

Hint 4

The R-L deconvolution uses convolution. Please DO NOT use convolution in the spatial domain (which is a slow operation). Transform everything to the frequency domain (DFT) where the convolution is just a multiplication.


Hint 5

The Wallis filter [3] was described in detail on Lecture 3:

![](Aspose.Words.c3515584-f475-4445-a33b-06a21856d85b.008.png)

Please check the [Lecture slides](https://moodle.ppke.hu/pluginfile.php/38364/mod_page/content/3/IPA_03_Conv2_Enhancement.pdf) (Slide 62).

*Suggestions on what parameter values to use:*

Desired local mean: ½ of the top value of the dynamic range Desired local contrast: ⅕ of the top value of the dynamic range Amax: from the [1, 5] interval p: something small (e.g. 0.2)


Hint 6

Texture samples of the Laws filtering should be fabricated by hand using small samples from each region of the input (restored, filtered) image.

Since the images are color, one can implement an RGB Laws filter which incorporates color info in the decision making. You can implement this by using 3D texture samples or by applying Laws filter on each color layer separately.

Please be smart and creative!


Hint 7

The regions on the segmented image should be represented by their corresponding cluster index (1, 2, 3).

Use the built-in function imagesc to visualize the result.


References

1. Richardson, William Hadley (1972). "Bayesian-Based Iterative Method of Image Restoration". JOSA. 62 (1): 55–59. doi:10.1364/JOSA.62.000055
1. Lucy, L. B. (1974). "An iterative technique for the rectification of observed distributions". Astronomical Journal. 79 (6): 745–754. doi:10.1086/111605
1. Wallis,  R., (1976). "An approach to the space variant restoration and enhancement of images". In: Proc. IEEE Conference on Computer Vision and Pattern, Naval Postgraduate School, Monterey, CA, USA


