![Logo](https://user-images.githubusercontent.com/53833717/221363833-8f73ec79-bfe4-4144-961f-e2a950a24254.png)
# **artiluxio**
## An image style transfer application
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![Stars](https://img.shields.io/github/stars/pguijas/artiluxio?color=green&label=Stars)

Artistic style transfer involves generating a new image called a pastiche by merging two input images - one that represents the content and another that represents the artistic style. It is one of the most thrilling advancements in deep learning in recent times. This application is used to transfer styles between images, allowing you to create new outputs full of creativity.

## 🤖 Demo

<p align="center">
 <img src="demo.gif" width='200'/>
</p>

## 🫳🏼 Usage

The application is oriented to be easy to use.
When you open the application you will see the main screen where you can create a new inference from the camera or a selected image from the gallery.
You will also be able to see the last created inferences and the available models.

When you have the desired image, a second screen will appear where you can apply the models mentioned above, you can also upload a new model or reset the image.

Once you have the image with the desired style, you can download and share it! 

## ✅ Highlights

- A simply way to improve creativity.
- Art generator.

## 📚 Documentation

It is well known among the AI community that the training, but also the inference, process of AI models is considerably demanding in terms of time and energy consumption. Therefore, we have followed several [Green Software Patterns](https://patterns.greensoftware.foundation/) to increase in some extent the efficiency of our software.

1. **Optimize the size of AI/ML models**. We have considered two models for our project, each of one is made up of two modules: one to predict the style features of an image, and another to transform the input image with those features. They consist in the same architecture but using different data types. Specifically, we have tested an image style transfer called [Magenta](https://tfhub.dev/google/magenta/arbitrary-image-stylization-v1-256/2). The first version uses float16, consisting in a 4.7Mb of prediction layer and 0.4Mb of style transfer module. The second, which uses int8, weighs 2.8Mb in the case of the prediction module and 0.2Mb in the case of the style transfer module, almost **half** the original size! However, the drawback of the second version is that it cannot be run on the GPU, so some tests should be launched to check whether the size of the model or the speed is preferable.

2. **Use efficient file format for AI/ML development**. The models are stored in a `.tflite` format which, according to the documentation: "... is represented in a **special efficient portable format** known as FlatBuffers. This provides several advantages ... such as reduced size (**small code footprint**) and **faster inference** (data is directly accessed without an extra parsing/unpacking step).

3. **Run AI models at the edge**. If the ML model is running on the cloud, the data needs to be transferred and processed on the cloud to the required format that can be used by the ML model for inference. To reduce the carbon footprint of our ML application, we have directly executed the AI models at the edge (mobile phone). Also, all the compute processing tasks such as image preprocessing is performed on the final device, showing a **null data transfer over the network**.

4. **Select a more energy efficient AI/ML framework**. Although we use Flutter for the presentation layer of the application, all the models are built on C++ libraries, which are more energy efficient than those built on other programming languages.

5. **Use energy efficient AI/ML models**. Nowadays, there exists very powerful style transfer models such as Stable Difussion. However, this type of models require very specialized hardware which usually consumes a lot of energy (especially the GPUs). Since we are executing our models at the edge, we have decided to employ a much lighter model such as  [Magenta](https://tfhub.dev/google/magenta/arbitrary-image-stylization-v1-256/2). As already mentioned, its size is just a couple of Mb so they are able to be run without problems on a standard mobile phone.

6. **Leverage pre-trained models and transfer learning for AI/ML development**. Training an AI model has a significant carbon footprint. Therefore, we have decided to search for already pre-trained models useful for our purposes. We have **reduced the training carbon footprint to 0!**.

7. **Adopt serverless architecture for AI/ML workload processes**. All the steps performed by our application are entirely done in the final device, so the computing resources are specifically optimized to only consume what they need in that moment.

8. **Cache data**. The inference process of the model is the most demanding step of our pipeline. In order to minimize the waiting time for the result, we cache the results so they can be visualized later instantly without the need for re-computation.

## 📥 Installation

Please take a minute to read the [TensorFlow Lite Flutter Plugin](https://pub.dev/packages/tflite_flutter) page to add TensorFlow Lite dynamic libraries to your app.

Desktop
```
flutter pub get
flutter run
```

## 📜 License

Multiple licences have been taken into account, such as Berkeley Software Distribution (BSD), Massachusetts Institute of Technology (MIT) or Apache, but the licence used in this project is [GNU General Public License, Version 3.0](https://www.gnu.org/licenses/gpl-3.0.en.html). The main reason for choosing GPLv3 was that it is somewhat more restrictive than the other candidates. Also, one of its most important points is that it is a copyleft licence,
i.e. it is required to preserve the same freedoms on copying and derivatives. In addition, it should be noted that GPLv3 is compatible with the licences of the libraries and tools used, which are indicated below.

- [Magenta model](https://github.com/magenta/magenta) --> Apache-2.0
- [cupertino_icons](https://pub.dev/packages/cupertino_icons/license) --> The MIT License
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) --> The MIT License
- [image_picker](https://pub.dev/packages/image_picker/license) --> Apache-2.0, BSD-3-Clause
- [flutter_speed_dial](https://pub.dev/packages/flutter_speed_dial) --> The MIT License
- [tflite_flutter](https://pub.dev/packages/tflite_flutter) --> Apache-2.0
- [photo_view](https://pub.dev/packages/photo_view) --> The MIT License
- [share_plus](https://pub.dev/packages/share_plus/license) --> BSD-3-Clause
- [flutter_lints](https://pub.dev/packages/flutter_lints) --> BSD-3-Clause
- [roboto font](https://github.com/googlefonts/roboto) --> Apache-2.0

Furthermore, it should be noted that the main objective of an open license is to enable a collaborative and open environment. In this way, the application can be expanded and/or adapted to the different needs that the community may have.

One of the main purposes is the inclusion of new models optimized for mobile as well as the future inclusion of adding the possibility of API for heavier models. All this with the aim of giving the greatest versatility and functionality to the application.  These lines of future work will be discussed in the next section.

Finally, it is worth highlighting that it has been initially promoted using the students' communication channels, trying to encourage the use and collaboration in the project.

## 📈 Future work

As mentioned, the current version only allows image processing using two small models locally. However, there will be multiple lines of future work, among which the following stand out:

- Inclusion of new models.
- Inclusion of larger models using an alternative cloud approach.
- Real-time inferences (using the camera).
- Creation of a marketplace for the community to publish their image-to-image models.
