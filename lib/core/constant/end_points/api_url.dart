
const baseUrl = 'https://task.jasim-erp.com/';


const getlistdrink = '${baseUrl}api/app/drink'; // GET


/////order url////////////

const String createDrinkOrderUrl = '${baseUrl}api/app/order';
const String changeDrinkOrderStatusUrl = '${baseUrl}api/app/Order/change-status';
const String getOrdersUrl = '${baseUrl}api/app/order';
const String getCurrentUserOrdersUrl = '${baseUrl}api/app/Order/current_user';
 const String createDrinkOrderLiteUrl = "$baseUrl/api/app/order";
/////auth_url////////////
///
const loginUrl = '${baseUrl}connect/token';
const registerUrl = '${baseUrl}api/app/users/mobile-register';


///user url////////////

const currentUserUrl = '${baseUrl}api/app/current-customer';
const getPlaceUrl = '${baseUrl}api/app/floor/offices/autocomplete';
const getUserAutocompleteUrl = '${baseUrl}api/app/user/autocomplete';

//floorplan / desk urls//
const String getFloorLayoutUrl =
    '${baseUrl}api/app/desk/floor-layout'; // GET /{floorId}
const String moveDeskUrl = '${baseUrl}api/app/desk/move'; // POST
const String assignUserToDeskUrl = '${baseUrl}api/app/desk/assign-user'; // POST
const String deskUrl = '${baseUrl}api/app/desk'; // GET list / POST / DELETE
// Document (floor-plan image) raw file bytes by Document id.
// Use the Document download route (lookup by document id) — NOT the DMS
// file-get route, which looks up by owning-entity id + entityType.
const String documentDownloadUrl =
    '${baseUrl}api/app/document/download'; // GET /{documentId}

//presence urls (Slice 2)//
const String presenceCheckInUrl =
    '${baseUrl}api/app/presence/check-in'; // POST { floorId?, deskId? }
const String presenceHeartbeatUrl =
    '${baseUrl}api/app/presence/heartbeat'; // POST (no body)
const String presenceCheckOutUrl =
    '${baseUrl}api/app/presence/check-out'; // POST (no body)
const String floorPresenceUrl =
    '${baseUrl}api/app/presence/floor'; // GET /{floorId}

//directory & department urls (Slice 2)//
const String directorySearchUrl =
    '${baseUrl}api/app/directory/search'; // GET ?Text=&DepartmentId=&FloorId=&Type=&SkipCount=&MaxResultCount=
const String departmentAutocompleteUrl =
    '${baseUrl}api/app/department/autocomplete'; // GET ?term=

//order//



