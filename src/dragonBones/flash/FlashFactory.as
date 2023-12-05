﻿package dragonBones.flash
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.getTimer;
	
	import dragonBones.Armature;
	import dragonBones.Slot;
	import dragonBones.animation.WorldClock;
	import dragonBones.core.BaseObject;
	import dragonBones.core.dragonBones_internal;
	import dragonBones.enum.DisplayType;
	import dragonBones.factories.BaseFactory;
	import dragonBones.factories.BuildArmaturePackage;
	import dragonBones.objects.ActionData;
	import dragonBones.objects.DisplayData;
	import dragonBones.objects.SkinSlotData;
	import dragonBones.objects.SlotData;
	import dragonBones.parsers.DataParser;
	import dragonBones.textures.TextureAtlasData;
	
	use namespace dragonBones_internal;
	
	/**
	 * @language zh_CN
	 * 基于 Flash 传统显示列表的工厂。
	 * @version DragonBones 3.0
	 */
	public class FlashFactory extends BaseFactory
	{
		/**
		 * @private
		 */
		protected static const _eventManager:FlashArmatureDisplay = new FlashArmatureDisplay();
		/**
		 * @private
		 */
		dragonBones_internal static const _clock:WorldClock = new WorldClock();
		/**
		 * @language zh_CN
		 * 一个可以直接使用的全局工厂实例.
		 * @version DragonBones 4.7
		 */
		public static const factory:FlashFactory = new FlashFactory();
		/**
		 * @private
		 */
		protected static function _clockHandler(event:Event):void 
		{
			const time:Number = getTimer() * 0.001;
			const passedTime:Number = time - _clock.time;
			_clock.advanceTime(passedTime);
			_clock.time = time;
		}
		/**
		 * @language zh_CN
		 * 创建一个工厂。
		 * @version DragonBones 3.0
		 */
		public function FlashFactory(dataParser:DataParser = null)
		{
			super(this, dataParser);
		}
		/**
		 * @private
		 */
		override protected function _generateTextureAtlasData(textureAtlasData:TextureAtlasData, textureAtlas:Object):TextureAtlasData
		{
			if (textureAtlasData)
			{
				if (textureAtlas is BitmapData)
				{
					(textureAtlasData as FlashTextureAtlasData).texture = textureAtlas as BitmapData;
				}
			}
			else
			{
				textureAtlasData = BaseObject.borrowObject(FlashTextureAtlasData) as FlashTextureAtlasData;
			}
			
			return textureAtlasData;
		}
		/**
		 * @private
		 */
		override protected function _generateArmature(dataPackage:BuildArmaturePackage):Armature
		{
			if (!_eventManager.hasEventListener(Event.ENTER_FRAME))
			{
				_clock.time = getTimer() * 0.001;
				_eventManager.addEventListener(Event.ENTER_FRAME, _clockHandler, false, -999999);
			}
			
			const armature:Armature = BaseObject.borrowObject(Armature) as Armature;
			const armatureDisplay:FlashArmatureDisplay = new FlashArmatureDisplay();
			armatureDisplay._armature = armature;
			
			armature._init(
				dataPackage.armature, dataPackage.skin,
				armatureDisplay, armatureDisplay, _eventManager
			);
			
			return armature;
		}
		/**
		 * @private
		 */
		override protected function _generateSlot(dataPackage:BuildArmaturePackage, skinSlotData:SkinSlotData, armature:Armature):Slot
		{
			const slot:FlashSlot = BaseObject.borrowObject(FlashSlot) as FlashSlot;
			const slotData:SlotData = skinSlotData.slot;
			const displayList:Vector.<Object> = new Vector.<Object>(skinSlotData.displays.length, true);
			const slotDisplay:Shape = new Shape();
			
			slot._init(skinSlotData, slotDisplay, slotDisplay);
			
			for (var i:uint = 0, l:uint = skinSlotData.displays.length; i < l; ++i) 
			{
				const displayData:DisplayData = skinSlotData.displays[i];
				switch (displayData.type)
				{
					case DisplayType.Image:
						if (!displayData.texture)
						{
							displayData.texture = _getTextureData(dataPackage.dataName, displayData.path);
						}
						
						if (dataPackage.textureAtlasName)
						{
							slot._textureDatas[i] = _getTextureData(dataPackage.textureAtlasName, displayData.path)
						}
						
						displayList[i] = slot.rawDisplay;
						break;
					
					case DisplayType.Mesh:
						if (!displayData.texture)
						{
							displayData.texture = _getTextureData(dataPackage.dataName, displayData.path);
						}
						
						if (dataPackage.textureAtlasName)
						{
							slot._textureDatas[i] = _getTextureData(dataPackage.textureAtlasName, displayData.path)
						}
						
						displayList[i] = slot.meshDisplay;
						break;
					
					case DisplayType.Armature:
						const childArmature:Armature = buildArmature(displayData.path, dataPackage.dataName, null, dataPackage.textureAtlasName);
						if (childArmature) 
						{
							if (!childArmature.inheritAnimation)
							{
								const actions:Vector.<ActionData> = slotData.actions.length > 0? slotData.actions: childArmature.armatureData.actions;
								if (actions.length > 0) 
								{
									for each (var action:ActionData in actions) 
									{
										childArmature._bufferAction(action);
									}
								} 
								else 
								{
									childArmature.animation.play();
								}
							}
							
							displayData.armature = childArmature.armatureData; // 
						}
						
						displayList[i] = childArmature;
						break;
					
					default:
						displayList[i] = null;
						break;
				}
			}
			
			slot._setDisplayList(displayList);
			
			return slot;
		}
		/**
		 * @language zh_CN
		 * 创建一个指定名称的骨架，并使用骨架的显示容器来更新骨架动画。
		 * @param armatureName 骨架数据名称。
		 * @param dragonBonesName 龙骨数据名称，如果未设置，将检索所有的龙骨数据，当多个数据中包含同名的骨架数据时，可能无法创建出准确的骨架。
		 * @param skinName 皮肤名称，如果未设置，则使用默认皮肤。
		 * @param textureAtlasName 贴图集数据名称，如果未设置，则使用龙骨数据名称。
		 * @return 骨架的显示容器。
		 * @see dragonBones.flash.FlashArmatureDisplay
		 * @version DragonBones 4.5
		 */
		public function buildArmatureDisplay(armatureName:String, dragonBonesName:String = null, skinName:String = null, textureAtlasName:String = null):FlashArmatureDisplay
		{
			const armature:Armature = buildArmature(armatureName, dragonBonesName, skinName, textureAtlasName);
			if (armature)
			{
				_clock.add(armature);
				return armature.display as FlashArmatureDisplay;
			}
			
			return null;
		}
		/**
		 * @language zh_CN
		 * 获取带有指定贴图的显示对象。
		 * @param textureName 指定的贴图名称。
		 * @param textureAtlasName 指定的贴图集数据名称，如果未设置，将检索所有的贴图集数据。
		 * @version DragonBones 3.0
		 */
		public function getTextureDisplay(textureName:String, textureAtlasName:String = null):Shape 
		{
			const textureData:FlashTextureData = _getTextureData(textureAtlasName, textureName) as FlashTextureData;
			if (textureData)
			{
				var width:Number = 0;
				var height:Number = 0;
				if (textureData.rotated)
				{
					width = textureData.region.height;
					height = textureData.region.width;
				}
				else
				{
					height = textureData.region.height;
					width = textureData.region.width;
				}
				
				const scale:Number = 1 / textureData.parent.scale;
				const helpMatrix:Matrix = new Matrix();
				
				if (textureData.rotated)
				{
					helpMatrix.a = 0;
					helpMatrix.b = -scale;
					helpMatrix.c = scale;
					helpMatrix.d = 0;
					helpMatrix.tx = - textureData.region.y;
					helpMatrix.ty = textureData.region.x + height;
				}
				else
				{
					helpMatrix.a = scale;
					helpMatrix.b = 0;
					helpMatrix.c = 0;
					helpMatrix.d = scale;
					helpMatrix.tx = - textureData.region.x;
					helpMatrix.ty = - textureData.region.y;
				}
				
				const shape:Shape = new Shape();
				shape.graphics.beginBitmapFill((textureData.parent as FlashTextureAtlasData).texture, helpMatrix, false, true);
				shape.graphics.drawRect(0, 0, width, height);
				
				return shape;
			}
			
			return null;
		}
		/**
		 * @language zh_CN
		 * 获取全局声音事件管理器。
		 * @version DragonBones 3.0
		 */
		public function get soundEventManager(): FlashArmatureDisplay
		{
			return _eventManager;
		}
	}
}