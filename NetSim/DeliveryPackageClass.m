classdef (ConstructOnLoad) DeliveryPackageClass < event.EventData
   properties
      package
   end
   
   methods
      function data = DeliveryPackageClass(delivery)
         data.package = delivery;
      end
   end
end


