const String printerIpAddress = '192.168.178.155';
const String prusalinkIpAddress = "192.168.178.129";
const int serviceControllerPort = 1933;
const int corsProxyPort = 8080;
const int mjpgStreamerIpAddress = 8000;

const String serviceControllerAddress = "$printerIpAddress:$serviceControllerPort";
const corsProxyAddress = "$printerIpAddress:$corsProxyPort";
const String mjpgStreamAddress = "http://$printerIpAddress:$mjpgStreamerIpAddress/?action=stream";
const String prusalinkAddress = "http://$prusalinkIpAddress/";
const String prusalinkPrinterApi = "http://$prusalinkIpAddress/api/printer";