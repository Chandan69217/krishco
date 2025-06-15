import 'dart:io';

class ProofModel {
  String? type;
  String idNumber = '';
  File? frontImage;
  String? frontImageUrl;
  File? backImage;
  String? backImageUrl;

  ProofModel();

  ProofModel.clone(ProofModel original)
      : type = original.type,
        idNumber = original.idNumber,
        frontImage = original.frontImage,
        frontImageUrl = original.frontImageUrl,
        backImage = original.backImage,
        backImageUrl = original.backImageUrl;
}