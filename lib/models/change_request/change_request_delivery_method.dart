enum ChangeRequestDeliveryMethod { mobileNumber, deviceSigning }

extension ChangeRequestDeliveryMethodExtension on ChangeRequestDeliveryMethod {
  get name {
    switch (this) {
      case ChangeRequestDeliveryMethod.mobileNumber:
        return "mobile_number";
      case ChangeRequestDeliveryMethod.deviceSigning:
        return "device_signing";
    }
  }
}
