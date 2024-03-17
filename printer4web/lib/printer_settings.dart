const String printerIpAddress = '192.168.178.150';
const String prusalinkIpAddress = "192.168.178.129";
const int serviceControllerPort = 1933;
const int corsProxyPort = 8080;
const int mjpgStreamerIpAddress = 8000;

const String serviceControllerAddress = "$printerIpAddress:$serviceControllerPort";
const corsProxyAddress = "$printerIpAddress:$corsProxyPort";
const String mjpgStreamAddress = "http://$printerIpAddress:$mjpgStreamerIpAddress/?action=stream";
const String prusalinkAddress = "http://$prusalinkIpAddress";
const String prusalinkPrinterApi = "$prusalinkAddress/api/printer";
const String prusalinkJobApi = "$prusalinkAddress/api/job";
const String prusalinkFilesApi = "$prusalinkAddress/api/files/local";
const String prusalinkThumbnailApi = "$prusalinkAddress/api/thumbnails";
const String prusalinkPreheatNozzleApi = "$prusalinkAddress/api/printer/tool";
const String prusalinkPreheatBedApi = "$prusalinkAddress/api/printer/bed";