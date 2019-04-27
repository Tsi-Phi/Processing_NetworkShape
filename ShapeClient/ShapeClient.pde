import processing.net.*;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;

Client netClient;

JSONObject clientData;
ShapeShared shapeShared;
 
void setup() { 
  shapeShared = new ShapeShared();
  
  size(500, 500); 
  background(shapeShared.screenBg);
  // Connect to the local machine at port 5204.
  // This example will not run if you haven't
  // previously started a server on this port.
  netClient = new Client(this, "192.168.1.7", 5204);
  
  clientData = new JSONObject();
  
  rectMode(CENTER);
  ellipseMode(CENTER);
  
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
  updateShape();
}

void updatePosition() {
  clientData.setInt(shapeShared.keyJsonMouseX, mouseX);
  clientData.setInt(shapeShared.keyJsonMouseY, mouseY);
  clientData.setInt(shapeShared.keyJsonSizeX, 30);
  clientData.setInt(shapeShared.keyJsonSizeY, 30);
}

void updateColour() {
  clientData.setInt(shapeShared.keyJsonColourR, int(random(0, 255)));
  clientData.setInt(shapeShared.keyJsonColourG, int(random(0, 255)));
  clientData.setInt(shapeShared.keyJsonColourB, int(random(0, 255)));
}

void updateShape() {
  clientData.setString(shapeShared.keyJsonShape, shapeShared.keyJsonShapeOptions[int(random(0,shapeShared.keyJsonShapeOptions.length))]);
}

void sendClientData() {
    String sendData = "";
    sendData = clientData.toString();
    
    netClient.write(sendData);
    
    background(shapeShared.screenBg);
    drawShape(clientData);
}

void drawShape(JSONObject sourceData) {
  String sourceDataShape;
  sourceDataShape = sourceData.getString(shapeShared.keyJsonShape);

  color clientColour = color(sourceData.getInt(shapeShared.keyJsonColourR), sourceData.getInt(shapeShared.keyJsonColourG), sourceData.getInt(shapeShared.keyJsonColourB));
  fill(clientColour);

  if(sourceDataShape == shapeShared.keyJsonShapeQuad){
     rect(sourceData.getInt(shapeShared.keyJsonMouseX), sourceData.getInt(shapeShared.keyJsonMouseY), sourceData.getInt(shapeShared.keyJsonSizeX), sourceData.getInt(shapeShared.keyJsonSizeY));
  } else if(sourceDataShape == shapeShared.keyJsonShapeEllipse){
     ellipse(sourceData.getInt(shapeShared.keyJsonMouseX), sourceData.getInt(shapeShared.keyJsonMouseY), sourceData.getInt(shapeShared.keyJsonSizeX), sourceData.getInt(shapeShared.keyJsonSizeY));
  } else {
    ellipse(sourceData.getInt(shapeShared.keyJsonMouseX), sourceData.getInt(shapeShared.keyJsonMouseY), 10, 10);
  }
}
