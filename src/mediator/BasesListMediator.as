package mediator
{
	import mx.collections.ArrayCollection;
	
	import dictionary.Const;
	
	import events.BasesListEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import proxy.BasesListProxy;
	
	import views.protoBasesView;
	
	import vo.BaseVO;
	import vo.RuinVO;
	
	public class BasesListMediator extends Mediator
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "basesListMediator";
		
		private var _basesListProxy:BasesListProxy;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function BasesListMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			applyViewComponent();
		}
		
		/**
		 * Источник данных для списка баз
		 */
		public function get basesDataProvider():ArrayCollection
		{
			var bases:Array = [];
			for each (var baseVO:BaseVO in basesListProxy.getBasesList())
			bases.push(baseVO);
			
			bases.sortOn("baseName");
			return new ArrayCollection(bases);
		}
		
		/**
		 * Источник данных для списка руин
		 */
		public function get ruinsDataProvider():ArrayCollection
		{
			var ruins:Array = [];
			for each (var ruinVO:RuinVO in basesListProxy.getRuinsList())
			ruins.push(ruinVO);
			
			ruins.sortOn("ruinName");
			return new ArrayCollection(ruins);
		}
		
		protected function get basesView():protoBasesView
		{
			return viewComponent as protoBasesView;
		}
		
		protected function get basesListProxy():BasesListProxy
		{
			if (!_basesListProxy)
			{
				_basesListProxy = this.facade.retrieveProxy(BasesListProxy.NAME) as BasesListProxy;
				
				if (!_basesListProxy)
					throw Error("Bases List Proxy must be specified.");
			}
			
			return _basesListProxy;
		}
		
		/**
		 * Освободить текущий визуальный компонент
		 */
		private function releaseViewComponent():void
		{
			if (!basesView)
				return;
			
			// TODO: Удалить все обработчики событий, если таковые были установлены
			
			basesView.removeEventListener(BasesListEvent.CREATE_BASE, createBaseHandler);
		}
		
		/**
		 * Инициализировать текущий визуальный компонент
		 */
		private function applyViewComponent():void
		{
			if (!basesView)
				return;
			
			// TODO: Проинициализировать поля компонента актуальными значениями, устновить оброботчики событий, если нужно
			
			basesView.basesList = basesDataProvider;
			basesView.buildNewBaseAvailable = basesListProxy.getRuinsList().length > 0;
			
			basesView.addEventListener(BasesListEvent.CREATE_BASE, createBaseHandler, false, 0, true);
			
			// /TODO
		}
		
		/**
		 * Обработчик запроса на создание новой базы
		 * @param event событие
		 */
		private function createBaseHandler(event:BasesListEvent):void
		{
			var ruinVO:RuinVO = event.valueObject as RuinVO;
			if (ruinVO)
				sendNotification(Const.CREATE_NEW_BASE, ruinVO);
		}
		
		//----------------------------------
		//  Mediator
		//----------------------------------
		
		override public function setViewComponent(viewComponent:Object):void
		{
			releaseViewComponent();
			super.setViewComponent(viewComponent);
			applyViewComponent();
		}
		
		override public function listNotificationInterests():Array
		{
			return [ Const.NEW_BASE_CREATED ];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case Const.NEW_BASE_CREATED:
					// После постройки базы изменился список баз и возможно исчезла возможность строить новые базы
					if (basesView)
					{
						basesView.basesList = basesDataProvider;
						basesView.buildNewBaseAvailable = basesListProxy.getRuinsList().length > 0;
					}
					break;
			}
		}
	}
}