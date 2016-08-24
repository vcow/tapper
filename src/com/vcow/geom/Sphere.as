package com.vcow.geom
{
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	import starling.display.Mesh;
	import starling.display.MeshBatch;
	import starling.rendering.IndexData;
	import starling.rendering.VertexData;
	import starling.textures.Texture;

	public class Sphere extends MeshBatch
	{
		private var _vertices:Vector.<Number>;
		private var _transformed:Vector.<Number>;
		private var _quads:Vector.<SphereQuad>;

		public function Sphere(r:Number = 200, tessellation:uint = 1, texture:Texture = null)
		{
			super();
			var numVertices:int = (4 * tessellation + 1) * (8 * tessellation);
			_transformed = new Vector.<Number>(numVertices * 3, true);
			_vertices = new Vector.<Number>(numVertices * 3, true);
			var ctr:uint = 0;
			var ang:Number = Math.PI / (4 * tessellation);
			for (var i:uint = 0, l:uint = 4 * tessellation; i <= l; i++)
			{
				var ca:Number = ang * i;
				var cr:Number = Math.sin(ca) * r;
				var cl:Number = Math.cos(ca) * r;
				for (var j:uint = 0, k:uint = 8 * tessellation; j < k; j++)
				{
					var pa:Number = ang * j;
					_transformed[ctr] = _vertices[ctr] = cr * Math.cos(pa);
					ctr++;
					_transformed[ctr] = _vertices[ctr] = -cl;
					ctr++;
					_transformed[ctr] = _vertices[ctr] = cr * Math.sin(pa);
					ctr++;
				}
			}

			ctr = 0;

			var pw:Number, ph:Number;
			if (texture)
			{
				pw = 1.0 / (8 * tessellation);
				ph = 1.0 / (4 * tessellation);
			}

			_quads = new Vector.<SphereQuad>(4 * 8 * tessellation * tessellation, true);
			for (i = 0, l = 4 * tessellation; i < l; i++)
			{
				for (j = 0, k = 8 * tessellation; j < k - 1; j++)
				{
					var quad:SphereQuad = new SphereQuad();
					quad.a = i * k + j + 1;
					quad.b = i * k + j;
					quad.c = i * k + j + k + 1;
					quad.d = i * k + j + k;
					if (texture)
					{
						quad.textureRegion = new flash.geom.Rectangle(1.0 - pw * (j + 1), i * ph, pw, ph);
					}
					_quads[ctr++] = quad;
				}
				if (j > 0)
				{
					quad = new SphereQuad();
					quad.a = i * k;
					quad.b = i * k + j;
					quad.c = (i + 1) * k;
					quad.d = (i + 1) * k + j;
					if (texture)
					{
						quad.textureRegion = new flash.geom.Rectangle(1.0 - pw * (j + 1), i * ph, pw, ph);
					}
					_quads[ctr++] = quad;
				}
			}

			for (i = 0, l = _quads.length; i < l; i++)
			{
				quad = _quads[i];
				var id:IndexData = new IndexData(4);
				id.addQuad(0, 1, 2, 3);
				var vd:VertexData = new VertexData(null, 4);
				quad.mesh = new Mesh(vd, id);
				if (texture)
				{
					quad.mesh.texture = texture;
					vd.setPoint(0, "texCoords", quad.textureRegion.left, quad.textureRegion.top);
					vd.setPoint(1, "texCoords", quad.textureRegion.right, quad.textureRegion.top);
					vd.setPoint(2, "texCoords", quad.textureRegion.left, quad.textureRegion.bottom);
					vd.setPoint(3, "texCoords", quad.textureRegion.right, quad.textureRegion.bottom);
				}
			}
			draw();
		}

		private const tm:Matrix3D = new Matrix3D();
		private const m:Matrix3D = new Matrix3D();
		private const pivot:Vector3D = new Vector3D();

		public function rotate(rx:Number, ry:Number, rz:Number):void
		{
			m.copyFrom(tm);
			if (rx) m.appendRotation(rx, Vector3D.X_AXIS, pivot);
			if (ry) m.appendRotation(ry, Vector3D.Y_AXIS, pivot);
			if (rz) m.appendRotation(rz, Vector3D.Z_AXIS, pivot);
			m.transformVectors(_vertices, _transformed);
			draw();
		}

		private const a:Vector.<Number> = new Vector.<Number>(3, true);
		private const b:Vector.<Number> = new Vector.<Number>(3, true);
		private const c:Vector.<Number> = new Vector.<Number>(3, true);
		private const d:Vector.<Number> = new Vector.<Number>(3, true);

		protected function draw():void
		{
			clear();

			var fill:Function = function (v:Vector.<Number>, ptIndex:uint):void
			{
				var i:uint = ptIndex * 3;
				v[0] = _transformed[i++];
				v[1] = _transformed[i++];
				v[2] = _transformed[i];
			};

			var equals:Function = function (v1:Vector.<Number>, v2:Vector.<Number>):Boolean
			{
				return v1[0] == v2[0] && v1[1] == v2[1] && v1[2] == v2[2];
			};

			for (var i:int = 0, l:int = _quads.length; i < l; i++)
			{
				var quad:SphereQuad = _quads[i];
				fill(a, quad.a);
				fill(b, quad.b);
				fill(c, quad.c);
				fill(d, quad.d);
				var nz:Number = equals(a, b) ? getNormal(b, d, c)[2] : getNormal(a, b, c)[2];
				if (nz < 0) continue;
				quad.mesh.setVertexPosition(0, a[0], a[1]);
				quad.mesh.setVertexPosition(1, b[0], b[1]);
				quad.mesh.setVertexPosition(2, c[0], c[1]);
				quad.mesh.setVertexPosition(3, d[0], d[1]);
				addMesh(quad.mesh);
			}
		}

		private const v1:Vector.<Number> = new Vector.<Number>(3, true);
		private const v2:Vector.<Number> = new Vector.<Number>(3, true);
		private const n:Vector.<Number> = new Vector.<Number>(3, true);

		private function getNormal(a:Vector.<Number>, b:Vector.<Number>, c:Vector.<Number>):Vector.<Number>
		{
			v1[0] = b[0] - a[0];
			v1[1] = b[1] - a[1];
			v1[2] = b[2] - a[2];
			v2[0] = c[0] - a[0];
			v2[1] = c[1] - a[1];
			v2[2] = c[2] - a[2];
			n[0] = v1[1] * v2[2] - v1[2] * v2[1];
			n[1] = v1[2] * v2[0] - v1[0] * v2[2];
			n[2] = v1[0] * v2[1] - v1[1] * v2[0];
			return n;
		}
	}
}


import flash.geom.Rectangle;

import starling.display.Mesh;

class SphereQuad
{
	public var a:uint;
	public var b:uint;
	public var c:uint;
	public var d:uint;
	public var mesh:Mesh;
	public var textureRegion:Rectangle;
}

