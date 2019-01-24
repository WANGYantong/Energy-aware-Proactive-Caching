function sec = setupSEC
   sec = SimpleEventClass;
   addlistener(sec,'Overflow',@overflowHandler);
   
   function overflowHandler(eventSrc,eventData)
      disp('The value of Prop1 is overflowing!')
      disp(['Its value was: ' num2str(eventData.OrgValue)])
      disp(['Its current value is: ' num2str(eventSrc.Prop1)])
   end


end