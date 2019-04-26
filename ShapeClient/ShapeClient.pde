import processing.net.*;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;

Client netClient;
JSONObject clientData;

final String keyJsonAddressMac = "addressMAC";
final String keyJsonMouseX = "mouseX";
final String keyJsonMouseY = "mouseY";
final String keyJsonSizeX = "sizeX";
final String keyJsonSizeY = "sizeY";
final String keyJsonColourR = "colourR";
final String keyJsonColourG = "colourG";
final String keyJsonColourB = "colourB";
final int screenBg = 255;
 
void setup() { 
  size(500, 500); 
  background(screenBg);
  // Connect to the local machine at port 5204.
  // This example will not run if you haven't
  // previously started a server on this port.
  netClient = new Client(this, "192.168.1.7", 5204);
  clientData = new JSONObject();
  String addressMAC = "";
  
  InetAddress ip;
  try {
      ip = InetAddress.getLocalHost();
      NetworkInterface network = NetworkInterface.getByInetAddress(ip);
      byte[] mac = network.getHardwareAddress();
      StringBuilder sb = new StringBuilder();
      
      for (int i = 0; i < mac.length; i++) {
        sb.append(String.format("%02X%s", mac[i], (i < mac.length - 1) ? "-" : ""));
      }
      addressMAC = sb.toString();
      
      clientData.setString("addressMAC", addressMAC);
      updateAll();
    } 
    catch (UnknownHostException e) {
      e.printStackTrace();
    } 
    catch (SocketException e) {
      e.printStackTrace();
  }
}

void draw() {
}

void clientEvent(Client someClient) {
}

void mouseClicked() {
  updateAll();
  sendClientData();
}

void mouseMoved(){
  updatePosition();
  sendClientData();
}

void updateAll() {
  updatePosition();
  updateColour();
}

void updatePosition() {
  clientData.setInt(keyJsonMouseX, mouseX);
  clientData.setInt(keyJsonMouseY, mouseY);
  clientData.setInt(keyJsonSizeX, 30);
  clientData.setInt(keyJsonSizeY, 30);
}

void updateColour() {
  clientData.setInt(keyJsonColourR, int(random(0, 255)));
  clientData.setInt(keyJsonColourG, int(random(0, 255)));
  clientData.setInt(keyJsonColourB, int(random(0, 255)));
}

void sendClientData() {
    String sendData = "";
    sendData = clientData.toString();
    
    netClient.write(sendData);
    
    background(screenBg);
    color clientColour = color(clientData.getInt(keyJsonColourR), clientData.getInt(keyJsonColourG), clientData.getInt(keyJsonColourB));
    fill(clientColour);
    ellipse(clientData.getInt(keyJsonMouseX), clientData.getInt(keyJsonMouseY), clientData.getInt(keyJsonSizeX), clientData.getInt(keyJsonSizeY));
}
