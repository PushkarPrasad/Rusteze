global key; %#ok<GVMIS>
brick.SetColorMode(3, 2);
threshold = 55;
temp = 0;% Initialize keyboard input before starting the loop
InitKeyboard();
while 1
  pause(0.1)
  % Regular movement and sensor checks
  touch = brick.TouchPressed(4);
  touch2 = brick.TouchPressed(1);
  color = brick.ColorCode(3);
  distance = brick.UltrasonicDist(2);
  brick.MoveMotor('D', 55); % left wheel (adjusted for balance)
  brick.MoveMotor('B', 54); % right wheel (balanced to match the left wheel)
   display(distance);
  if key == 'k'
      disp('Kill switch or stop key pressed. Exiting...');
      brick.StopMotor('BD', 'Brake');
      break;
  end
  display(color);
  if color == 5
      disp("Red");
      brick.StopMotor('BD', 'Brake');
      brick.playTone(10, 1000, 1000);
      pause(1);
      brick.MoveMotor('D', 55);
      brick.MoveMotor('B', 55);
      pause(1);
  elseif color == 3
      disp("Green");
      brick.StopMotor('BD', 'Brake');
      brick.playTone(10, 1000, 1000);
      pause(0.1);
      brick.playTone(10, 1000, 1000);
      pause(0.1);
      brick.playTone(10, 1000, 1000);
      pause(0.1);
      temp = 1;
  elseif color == 2
      disp("Blue");
      brick.StopMotor('BD', 'Brake');
      brick.playTone(10, 1000, 1000);
      pause(0.1);
      brick.playTone(10, 1000, 1000);
      pause(0.1);
      temp = 1;
  end
  while temp
      pause (0.1);
      % Update keypress every loop iteration
      switch key
          case 'uparrow'
              disp('Up Arrow Pressed');
              brick.MoveMotor('D', 40);
              brick.MoveMotor('B', 40);
          case 'downarrow'
              disp('Down Arrow Pressed');
              brick.MoveMotor('D', -40);
              brick.MoveMotor('B', -40);
          case 'leftarrow'
              disp('Left Arrow Pressed');
              brick.MoveMotorAngleRel('B', 40, 90, 'Brake');
              brick.MoveMotorAngleRel('D', -40, 90, 'Brake');
          case 'rightarrow'
              disp('Right Arrow Pressed');
              brick.MoveMotorAngleRel('D', 40, 90, 'Brake');
              brick.MoveMotorAngleRel('B', -40, 90, 'Brake');
          case 'p'
              disp('Beep Beep');
              brick.MoveMotor('C', -15);
          case 'o'
              disp('Beep Beep');
              brick.MoveMotor('C', 15)
          case 0
              disp('No Key Pressed');
              brick.StopMotor('BD', 'Coast');
              brick.StopMotor('C', 'Coast');
          case 'q'
              disp('Exiting Keyboard Input');
              temp = 0;
      end
  end
  % Navigation based on distance
  if distance >= threshold % turn right
      brick.MoveMotor('D', -55);
      brick.MoveMotor('B', -55);
      pause(0.5);
      brick.StopMotor('DB', 'Brake');
      brick.MoveMotor('B', -55);
      brick.MoveMotor ('D', 55);
      pause(.8); % turning time (adjusted if necessary)
      brick.StopMotor('BD', 'Brake');
      brick.MoveMotor('D', 55);
      brick.MoveMotor('B', 55);
      pause(2);
      if distance == 18 % adjust to the right
      brick.StopMotor('B', "Brake");
      brick.MoveMotor('D', 50);
      pause(0.1);
      brick.MoveMotor('DB', 50);
      pause(1);
  end
   if distance <= 9
       % Too close — soft left curve
       disp("Too close - adjusting left");
      % brick.MoveMotor('D', 30);  % Left wheel slower
       brick.MoveMotor('B', 55);% Right wheel normal
       brick.StopMotor('D','Brake');
       pause(0.1);
       brick.MoveMotor('DB',55);
       pause(0.1);
   end
  end
    if touch || touch2
      disp("I'm being touched");
      if distance < threshold % turn left
          brick.StopMotor('DB');
          pause(1);
          brick.MoveMotor('D', -55);
          brick.MoveMotor('B', -55);
          pause(1);
          brick.StopMotor('DB');
          brick.MoveMotor('D', -55);
          brick.MoveMotor('B', 55);
          pause(.95);
          brick.StopMotor('DB', 'Brake');
          brick.MoveMotor('D', 55);
          brick.MoveMotor('B', 55);
      else % turn right
          brick.StopMotor('DB');
          pause(1);
          brick.MoveMotor('D', -55);
          brick.MoveMotor('B', -55);
          pause(1);
          brick.StopMotor('DB');
          brick.MoveMotor('D', 55);
          brick.MoveMotor('B', -55);
          pause(.95);
          brick.StopMotor('DB', 'Brake');
          brick.MoveMotor('D', 55);
          brick.MoveMotor('B', 55);
      end
   end
end
CloseKeyboard();

