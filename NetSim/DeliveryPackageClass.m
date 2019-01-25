classdef (ConstructOnLoad) DeliveryPackageClass < event.EventData
   properties
      Package
   end
   
   methods
      function data = DeliveryPackageClass(delivery)
         data.Package = delivery;
      end
   end
end


