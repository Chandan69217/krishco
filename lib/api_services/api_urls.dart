class Urls {
  static const String base_url = 'krishco.com';
            // Authentication
  static const String login = '/api/login/';
  static const String register = '/api/register/';
            // State-District
  static const String get_state_list = '/api/stats/';
  static const String get_district_list = '/api/distic/';
  static const String get_city_list = '/api/city/';
            // Product Details
  static const String product_catagory = '/api/product-category/';
  static const String product_details_by_id = '/api/product-category/';
            // Tagged Enterprise
  static const String tagged_enterprise_of_login_customer = '/api/tagged-enterprise/';
  static const String tagged_enterprise_of_given_number = '/api/tagged-enterprise/';
            // Group Details
  static const String get_group_details_by_number = '/api/customer-details/';
  static const String get_group_category = '/api/customer-category/';
  static const String get_group_by_category_id = '/api/customer-category/';
            // Order Related
  static const String order_entry_for_self = '/api/place-order/create/';
  static const String order_list = '/api/place-order/list/';
  static const String order_view_by_id = '/api/place-order/1/view/';
  static const String order_reporting_list = '/api/place-order/reporting-message/';
  static const String order_reporting_list_search = '/api/place-order/reporting-message/';
  static const String order_list_search = '/api/place-order/list/';
  static const String order_entry_for_others = '/api/place-order/create/';
            // Claim Invoice
  static const String invoice_claim_list = '/api/invoice/claim/list/';
  static const String invoice_claim_entry = '/api/invoice/claim/create/';
  static const String invoice_claim_view = '/api/invoice/claim/';
  static const String invoice_claim_drop_out = '/api/invoice/claim/';
  static const String invoice_claim_reporting_list = '/api/invoice/claim/reporting-message/';
  static const String invoice_claim_recall = '/api/invoice/claim/';
            // Change Password
  static const String change_password = '/api/change-password/';

          // Transportation
static const String get_transportation_details = '/api/get-transporter-details/';

          // Warranty Related
static const String warranty_registration = '/api/warranty/add/';
static const String warranty_list = '/api/warranty/list/';

          // Support Related
static const String support_details =  '/api/get-support-details/';

          // Consumers Groups
static const String consumers_group = '/api/customer-groups/';
          // Product Catalogues
static const String product_catalogues = '/api/product-catalogue/';
          // Redemption Catalogues
static const String redemptionCatalogues = '/api/redemption-catalogue/';
        // Suggestion and Query
static const String query_center = '/api/query-center/entry/';
static const String query_center_list = '/api/query-center/list/';


}