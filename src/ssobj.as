package{
		
	import com.gaiaframework.debug.GaiaDebug;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	public class ssobj extends Sprite{
		
		//持久化存储对象
		private static var cs:SharedObject;	
		
		public function ssobj()
		{
			//舞台准备好后创建应用
			this.addEventListener(Event.ADDED_TO_STAGE, buildApp);		
		}
		
		private function buildApp(event:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, buildApp);
			
			GaiaDebug.log(">>> ssobjc initialized...");
			
			if(ExternalInterface.available){
				try{
					GaiaDebug.log(">>> to add callback: cacheUserForFlash");
					ExternalInterface.addCallback("cacheUserForFlash", rememberUser);				
				}catch(e:SecurityError){
					GaiaDebug.error(">>> add callback SecurityError!");
				}catch(e:Error){
					GaiaDebug.error(">>> add callback Error!");
				}
			}else{
				GaiaDebug.warn(">>> ExternalInterface inavailable !!!");
			}
			
		}
		
		private function rememberUser(userId:String, userRole:String):void{
			//同时保存到sharedobject文件			
			//FIXME, ADD LOACALPATH FOR MULTI SWF ACCESS
			//2012/02/01
			cs = SharedObject.getLocal("ipintu", "/");			
			cs.data["userId"] = userId;
			cs.data["roleName"] = userRole;
			//存文件
			var result:String = cs.flush(500);
			//判断是否保存成功
			if(result==SharedObjectFlushStatus.FLUSHED){
				GaiaDebug.log("User cache succeed!");
			}
		}
		
	} //end of class
}