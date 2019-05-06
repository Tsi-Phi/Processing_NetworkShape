import processing.net.*;

Server netServer;
ArrayList<String> clientMacAddresses;
ArrayList<JSONObject> clientDataObjects;

final String keyJsonAddressMac = "addressMAC";
final String keyJsonMouseX = "mouseX";
final String keyJsonMouseY = "mouseY";
final String keyJsonSizeX = "sizeX";
final String keyJsonSizeY = "sizeY";
final String keyJsonColourR = "colourR";
final String keyJsonColourG = "colourG";
final String keyJsonColourB = "colourB";
final String keyJsonShapeQuad = "QUAD";
final String keyJsonShapeEllipse = "ELLIPSE";
final String keyJsonShape = "ELLIPSE";
final int screenBg = 255;

void setup() {
  size(500, 500); 
  background(screenBg);
  // Starts a myServer on port 5204
  netServer = new Server(this, 5204);
  clientMacAddresses = new ArrayList<String>();
  clientDataObjects = new ArrayList<JSONObject>();
  
  rectMode(CENTER);
  ellipseMode(CENTER);
}

void draw() {
  Client netClient = netServer.available();
  
  if(netClient != null) {
    String clientData = netClient.readString();
    
    if (clientData != null) {
      //println(netClient.ip() + "=" + clientData);
      JSONObject clientJSON = parseJSONObject(clientData);
      
      if(clientJSON != null) {
        int clientIndex;
        
        clientIndex = updateClient(clientJSON);
        
        drawClientData();
      }
    }
  }
}

int updateClient(JSONObject updatedClient){
  String addressMAC; 
  int clientIndex;
  addressMAC = updatedClient.getString(keyJsonAddressMac);
  clientIndex = clientMacAddresses.indexOf(addressMAC);
  
  if(clientIndex < 0){
    int clientCount;
    
    clientCount = clientMacAddresses.size();
    clientMacAddresses.add(clientCount,addressMAC);
    clientDataObjects.add(clientCount,updatedClient);
    
    clientIndex = clientCount;
  }
  else {
    clientDataObjects.set(clientIndex,updatedClient);
  }
  return clientIndex;
}

void drawClientData(){
  background(screenBg);
  for(int i = 0; i < clientDataObjects.size(); i++)
  {
    JSONObject clientJSON = clientDataObjects.get(i);
    
    drawShape(clientJSON);
  }
}

void drawShape(JSONObject sourceData) {
  String sourceDataShape;
  sourceDataShape = sourceData.getString(keyJsonShape);
  
  color clientColour = color(sourceData.getInt(keyJsonColourR), sourceData.getInt(keyJsonColourG), sourceData.getInt(keyJsonColourB));
  fill(clientColour);

  if(sourceDataShape.equals(keyJsonShapeQuad)){
     rect(sourceData.getInt(keyJsonMouseX), sourceData.getInt(keyJsonMouseY), sourceData.getInt(keyJsonSizeX), sourceData.getInt(keyJsonSizeY));
  } else if(sourceDataShape.equals(keyJsonShapeEllipse)){
     ellipse(sourceData.getInt(keyJsonMouseX), sourceData.getInt(keyJsonMouseY), sourceData.getInt(keyJsonSizeX), sourceData.getInt(keyJsonSizeY));
  } else {
    ellipse(sourceData.getInt(keyJsonMouseX), sourceData.getInt(keyJsonMouseY), 10, 10);
  }
}
