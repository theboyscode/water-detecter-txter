// Signal Strength


// Output port to send temperature readings
local output = OutputPort("RSSI", "table");
  
// Register with the server
imp.configure("SMS Twilio Direct on small board v01d01", [], []);

// Capture and log a temperature reading every 5s
function capture()
{
    server.log("Just captured")
    // Setup our pins
    hardware.pin7.configure(ANALOG_IN);
    
    // Setup variables
    local message_string;
    
    // Get the resistance of the sensor 
    local resistance = hardware.pin7.read()
    
    // Check if water present
    if (resistance < 50000.0)
    {
        message_string = format("WATER DETECTED.  The resistance is  %3.1f", resistance);
        server.log(message_string);
        agent.send("alarm",message_string);
        server.log("data sent");
        imp.wakeup(300.0, capture)
    }
    else
    {
        message_string = format("Jan 2015. No water.  The resistance is  %3.1f", resistance);
        server.log(message_string);
        //////////////////////////
        //agent.send("alarm",message_string);
        //server.log("data sent");
        ////////////////////////
        
        // Set timer for the next capture only if no water detected
        imp.wakeup(300.0, capture);
    }
}

server.log("got here, yo");
capture();
// End of code.
