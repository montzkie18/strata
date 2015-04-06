package common
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	
	public class Image extends EventDispatcher
	{
		private var _image:IBitmapDrawable;
		
		private var _transform:Matrix;
		
		public function Image(image:IBitmapDrawable)
		{
			_image = image;
			_transform = new Matrix();
		}
		
		public function get image():IBitmapDrawable
		{
			return _image;
		}
		
		public function set image(value:IBitmapDrawable):void
		{
			_image = value;
		}
		
		public function get transform():Matrix
		{
			return _transform;
		}
		
		public function get width():int
		{
			if(_image is BitmapData)
				return (_image as BitmapData).width;
			else if(_image is DisplayObject)
				return (_image as DisplayObject).width;
			else
				return 0;
				
		}
		
		public function get height():int
		{
			if(_image is BitmapData)
				return (_image as BitmapData).height;
			else if(_image is DisplayObject)
				return (_image as DisplayObject).height;
			else
				return 0;
		}
	}
}