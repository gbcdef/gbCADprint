;;;==================================================================
;;;
;;;使用说明:
;;;
;;;1.手动在D盘下建立一个"_gbCADprint"文件夹（新版不再需要）
;;;2.Ctrl+P设置打印参数（如打印线宽、样式表、透明度、图幅等），点击"应用到布局"
;;;3.关闭AutoCAD自带的DWG TO PDF打印机自定义属性中“查看打印结果”一项。
;;;4.将打印线框使用rectangle绘制于图层0_PRINT_AUTHOR_GUIBIN上
;;;5.模型空间中输入GBDY开始批量打印,图纸空间中输入GBDYBJ开始批量打印
;;;
;;;2013年7月22日
;;;
;;;
;;;
;;;2015年10月21日更新：
;;;1.增加了对图幅的横竖判断，可同时打印横竖幅图纸
;;;2.打印比例默认为布满图纸，不再提供指定打印比例选项
;;;3.增加了输出目录及文件名设置，不再需要手工建立输出文件夹
;;;
;;;==================================================================

(vl-load-com)

(defun gbprintinitial ()
  (setq ks (tblsearch "layer" "0_PRINT_AUTHOR_GUIBIN"))
  (if (= ks nil)
    (command "-layer" "n" "0_PRINT_AUTHOR_GUIBIN" "")
  )
  (command "-layer" "p" "n" "0_PRINT_AUTHOR_GUIBIN" "")
  (command "-layer"	    "c"		     "t"
	   "63,67,62"	    "0_PRINT_AUTHOR_GUIBIN"
	   ""
	  )
)

(gbprintinitial)

(defun c:gbdy ()
  (setq ss (ssget "x" '((8 . "0_PRINT_AUTHOR_GUIBIN"))))
  (if (= ss nil)
    (progn
      (alert "图层“0_PRINT_AUTHOR_GUIBIN”中找不到打印线框！")
      (exit)
    )
  )
;;;(setq
;;;  scale (getstring nil "输入打印比例（如1：100输入\"1=100\"） 布满图纸<F>")
;;;)

  (setq	path (vl-string-right-trim
	       ".pdf"
	       (getfiled "使用gbCADprint打印到..." "" "pdf" 1)
	     )

  )

  (setq len (sslength ss))
  (setq i 0)
  (repeat len
    (setq r (ssname ss i))
    (setq i (+ i 1))
    (setq filename (strcat path (itoa i)))
    (setq en (vlax-ename->vla-object r))
    (setq vp1 (vla-get-coordinate en 0)
	  vp2 (vla-get-coordinate en 2)
    )
    (setq x1 (vlax-safearray-get-element (vlax-variant-value vp1) 0)
	  y1 (vlax-safearray-get-element (vlax-variant-value vp1) 1)
	  x2 (vlax-safearray-get-element (vlax-variant-value vp2) 0)
	  y2 (vlax-safearray-get-element (vlax-variant-value vp2) 1)
    )
    (setq p1 (list x1 y1 0)
	  p2 (list x2 y2 0)
    )

    (if	(< (abs (- x1 x2))
	   (abs (- y1 y2))
	)
      (setq orientation "p")
      (setq orientation "l")
    )



    (command "-plot"			;
	     "y"			;详细配置
	     ""				;选择布局
	     "DWG To PDF.pc3"		;打印设备名称
	     ""				;打印尺寸
	     "m"			;图纸单位,i英寸，m毫米
	     orientation		;图形方向,p纵向，l横向
	     ""				;上下颠倒
	     "w"			;打印区域
	     p1				;
	     p2				;
	     ""				;打印比例，图纸单位=图形单位，f布满
	     ""				;打印偏移，c居中打印
	     "y"			;使用样式表
	     ""				;打印样式名称，.无
	     ""				;打印线宽
	     ""				;着色设置
	     filename			;文件保存位置
	     "y"			;保存打印设置
	     "y"			;继续打印
	    )
  )
)

(defun c:gbdybj ()
  (setq ss (ssget "x" '((8 . "0_PRINT_AUTHOR_GUIBIN"))))
  (if (= ss nil)
    (progn
      (alert "图层“0_PRINT_AUTHOR_GUIBIN”中找不到打印线框！")
      (exit)
    )
  )

  (setq	path (vl-string-right-trim
	       ".pdf"
	       (getfiled "使用gbCADprint打印到..." "" "pdf" 1)
	     )

  )

  (setq len (sslength ss))
  (setq i 0)
  (repeat len
    (setq r (ssname ss i))
    (setq i (+ i 1))
    (setq filename (strcat path (itoa i)))
    (setq en (vlax-ename->vla-object r))
    (setq vp1 (vla-get-coordinate en 0)
	  vp2 (vla-get-coordinate en 2)
    )
    (setq x1 (vlax-safearray-get-element (vlax-variant-value vp1) 0)
	  y1 (vlax-safearray-get-element (vlax-variant-value vp1) 1)
	  x2 (vlax-safearray-get-element (vlax-variant-value vp2) 0)
	  y2 (vlax-safearray-get-element (vlax-variant-value vp2) 1)
    )
    (setq p1 (list x1 y1 0)
	  p2 (list x2 y2 0)
    )

    (if	(< (abs (- x1 x2))
	   (abs (- y1 y2))
	)
      (setq orientation "p")
      (setq orientation "l")
    )



    (command "-plot"			;
	     "y"			;详细配置
	     ""				;选择布局
	     "DWG To PDF.pc3"		;打印设备名称
	     ""				;打印尺寸
	     "m"			;图纸单位,i英寸，m毫米
	     orientation		;图形方向,p纵向，l横向
	     ""				;上下颠倒
	     "w"			;打印区域
	     p1				;
	     p2				;
	     ""				;打印比例，图纸单位=图形单位，f布满
	     ""				;打印偏移，c居中打印
	     "y"			;使用样式表
	     ""				;打印样式名称，.无
	     ""				;打印线宽
	     ""				;着色设置
	     ""
	     ""
	     filename			;文件保存位置
	     "y"			;保存打印设置
	     "y"			;继续打印
	    )
  )
)