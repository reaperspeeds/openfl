package openfl.display3D; #if !flash


import lime.graphics.opengl.GLBuffer;
import lime.utils.ArrayBufferView;
import lime.utils.Int16Array;
import openfl.utils.ByteArray;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)


@:final class IndexBuffer3D {
	
	
	@:noCompletion private var __context:Context3D;
	@:noCompletion private var __elementType:Int;
	@:noCompletion private var __id:GLBuffer;
	@:noCompletion private var __memoryUsage:Int;
	@:noCompletion private var __numIndices:Int;
	@:noCompletion private var __tempInt16Array:Int16Array;
	@:noCompletion private var __usage:Int;
	
	
	@:noCompletion private function new (context3D:Context3D, numIndices:Int, bufferUsage:Context3DBufferUsage) {
		
		__context = context3D;
		__numIndices = numIndices;
		
		var gl = __context.gl;
		__elementType = gl.UNSIGNED_SHORT;
		__id = gl.createBuffer ();
		
		__usage = (bufferUsage == Context3DBufferUsage.DYNAMIC_DRAW) ? gl.DYNAMIC_DRAW : gl.STATIC_DRAW;
		
	}
	
	
	public function dispose ():Void {
		
		var gl = __context.gl;
		gl.deleteBuffer (__id);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, startOffset:Int, count:Int):Void {
		
		var offset = byteArrayOffset + startOffset * 2;
		uploadFromTypedArray (new Int16Array (data.toArrayBuffer (), offset, count));
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView, byteLength:Int = -1):Void {
		
		if (data == null) return;
		var gl = __context.gl;
		__context.__bindGLElementArrayBuffer (__id);
		gl.bufferData (gl.ELEMENT_ARRAY_BUFFER, data, __usage);
		
	}
	
	
	public function uploadFromVector (data:Vector<UInt>, startOffset:Int, count:Int):Void {
		
		// TODO: Optimize more
		
		if (data == null) return;
		var gl = __context.gl;
		
		var length = startOffset + count;
		var existingInt16Array = __tempInt16Array;
		
		if (__tempInt16Array == null || __tempInt16Array.length < count) {
			
			__tempInt16Array = new Int16Array (count);
			
			if (existingInt16Array != null) {
				
				__tempInt16Array.set (existingInt16Array);
				
			}
			
		}
		
		for (i in startOffset...length) {
			
			__tempInt16Array[i - startOffset] = data[i];
			
		}
		
		uploadFromTypedArray (__tempInt16Array);
		
	}
	
	
}


#else
typedef IndexBuffer3D = flash.display3D.IndexBuffer3D;
#end