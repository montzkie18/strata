package battle
{
	import animation.AnimatedImage;
	import animation.AnimationSet;
	import animation.AnimationSetPool;
	
	import flash.display.Sprite;

	public class SoldierUnit extends Sprite
	{
		private var _image:AnimatedImage;
		private var _animPool:AnimationSet;
		
		public function SoldierUnit(image:AnimatedImage, animationPool:AnimationSetPool)
		{
			_image = image;
			_animPool = animationPool;
		}
	}
}