class DefineRoles{
  DefineRoles._();
  static _UserRoles user = _UserRoles();
  static _ChannelPartnerRoles channel_partner = _ChannelPartnerRoles();
  static _ConsumerRoles consumer = _ConsumerRoles();
  static _Influencer influencer = _Influencer();
}

class _UserRoles{
  _UserRoles();
  final String Who_can_claim_points_by_uploading_invoice = 'Who_can_claim_points_by_uploading_invoice';
  final String Who_can_see_and_change_in_query_list = "Who_can_see_and_change_in_query_list";
  final String View_Own_Tree_Node = "View_Own_Tree_Node";
  final String Who_can_place_order = "Who_can_place_order";
  final String Create_Product_Rule = "Create_Product_Rule";
  final String Create_Referral_Rule = "Create_Referral_Rule";
  final String Create_Claim_Invoice_Rule = "Create_Claim_Invoice_Rule";
}

class _ChannelPartnerRoles{
  _ChannelPartnerRoles();
  final String edit_your_details =  "edit_your_details";
  final String Who_can_claim_points_by_uploading_invoice = "Who_can_claim_points_by_uploading_invoice";
  final String Who_can_place_order = "Who_can_place_order";
}

class _ConsumerRoles{
  _ConsumerRoles();
  final String edit_your_details = "edit_your_details";
  final String Who_can_claim_points_by_uploading_invoice = "Who_can_claim_points_by_uploading_invoice";
  final String Who_can_place_order = "Who_can_place_order";
}

class _Influencer{
  _Influencer();
  final String edit_your_details = "edit_your_details";
  final String Who_can_claim_points_by_uploading_invoice = "Who_can_claim_points_by_uploading_invoice";
  final String Who_can_place_order = "Who_can_place_order";
}