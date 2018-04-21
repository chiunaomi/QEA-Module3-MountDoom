pub = rospublisher('/raw_vel');
sub_bump = rossubscriber('/bump');
sub_accel = rossubscriber('/accel');
msg = rosmessage(pub);

% omega = 0.1;
% d = .245;
omegal_clockwise = 0.07;
omegar_clockwise = -0.07;
omegal_counterclockwise = omegar_clockwise;
omegar_counterclockwise = omegal_clockwise;

v = 0.1;
vl = v;
vr = v;

accelMessage = receive(sub_accel);
while accelMessage.Data(3) < 2
    while accelMessage.Data(2)< -0.01
        Vl = omegal_clockwise;
        Vr = omegar_clockwise;
        msg.Data = [Vl,Vr];
        send(pub,msg);
        pause(0.1);
        accelMessage = receive(sub_accel);
    end
    
    while accelMessage.Data(2) > 0.01
        Vl = omegal_counterclockwise;
        Vr = omegar_counterclockwise;
        msg.Data = [Vl,Vr];
        send(pub,msg);
        pause(0.1);
        accelMessage = receive(sub_accel);
    end
    
    msg.Data = [vl,vr];
    send(pub,msg);
    pause(0.8)
    msg.Data = [0,0];
    send(pub,msg);
    
    bumpMessage = receive(sub_bump);
    if any(bumpMessage.Data)
        msg.Data = [0.0, 0.0];
        send(pub, msg);
        pause(0.1);
        break;
    end
     accelMessage = receive(sub_accel);
end
