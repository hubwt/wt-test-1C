Перем КаталогДанных;
Перем ФайлСкрипта;
Перем Эксплорер;

Функция Инициализация(мЭксплорер, Принудительно = Ложь) Экспорт
	Эксплорер = мЭксплорер;
	
	ДвоичныеДанные = ПолучитьМакет("TinyMCE_zip");
	КаталогДанных = КаталогВременныхФайлов() + "TinyMCE\";
	КаталогСкриптов = КаталогДанных + "tinymce\";
	ФайлАрхива = КаталогДанных + "TinyMCE.zip";
	
	ФайлКаталогСкриптов = Новый Файл(КаталогСкриптов);
	ФайлСкрипта = КаталогСкриптов + "tinyMCE\jscripts\tiny_mce\tiny_mce.js";
	Файл = Новый Файл(ФайлСкрипта);
	Если НЕ Принудительно И ФайлКаталогСкриптов.Существует() И Файл.Существует() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Файл = Новый Файл(КаталогСкриптов);
	Если НЕ Файл.Существует() Тогда
		СоздатьКаталог(КаталогСкриптов);
	КонецЕсли;
	
	Попытка
		ДвоичныеДанные.Записать(ФайлАрхива);
	Исключение
		Сообщить(ОписаниеОшибки(), СтатусСообщения.Информация);
		Возврат Ложь;
	КонецПопытки;
	
	зип = Новый ЧтениеZipФайла(ФайлАрхива);
	зип.ИзвлечьВсе(КаталогСкриптов, РежимВосстановленияПутейФайловZIP.Восстанавливать);
	УдалитьФайлы(ФайлАрхива);
	
	Возврат Истина;
КонецФункции

Процедура ПоказатьТекст(Текст, Редактирование = Ложь, ФайлCSS = Неопределено) Экспорт
	ТекстНастроек = ПолучитьМакет("TinyMCE_txt").ПолучитьТекст();
	
	Т = Новый ТекстовыйДокумент;
	Т.ДобавитьСтроку("<HTML><HEAD><meta http-equiv=""Content-Type"" content=""text/html; charset=windows-1251"" content=""no-cache"">");
	Если Редактирование И ЗначениеЗаполнено(ТекстНастроек) Тогда
		Т.ДобавитьСтроку("<script type=""text/javascript"" src=""tinyMCE/tinyMCE/jscripts/tiny_mce/tiny_mce.js""></script>");
		Т.ДобавитьСтроку(ТекстНастроек);
		Т.ДобавитьСтроку("</HEAD><BODY><FONT FACE=""Arial"" SIZE=""-1"">");
		Т.ДобавитьСтроку("<form method=""\"" action=""\"" onsubmit=""return false;"">");
		Т.ДобавитьСтроку("<textarea id=""elm1"" name=""elm1"" style=""width: 100%;height:100%"">");
	Иначе
		Т.ДобавитьСтроку("</HEAD><BODY><FONT FACE=""Arial"" SIZE=""-1"">");
	КонецЕсли;
	
	Т.ДобавитьСтроку(Текст);
	
	Если Редактирование И ЗначениеЗаполнено(ТекстНастроек) Тогда
		Т.ДобавитьСтроку("</textarea>");
	КонецЕсли;
	
	Т.ДобавитьСтроку("</FONT></BODY></HTML>");
	
	Если ФайлCSS <> Неопределено Тогда
		Файл = Новый Файл(ФайлCSS);
		Если Файл.Существует() Тогда
			КопироватьФайл(ФайлCSS, КаталогДанных + "temp.css");
			
			ВремТекст = Т.ПолучитьТекст();
			ВремТекст = СтрЗаменить(ВремТекст, "[CSS]", КаталогДанных + "temp.css");
			Т.УстановитьТекст(ВремТекст);
		КонецЕсли;
	КонецЕсли;
			
	ВремФайл = КаталогДанных + "temp.html";
	Т.Записать(ВремФайл, КодировкаТекста.ANSI);
	
	Эксплорер.Перейти(ВремФайл);
КонецПроцедуры

Функция ПолучитьТекст() Экспорт
	ОбластьТекста = Эксплорер.Документ.getElementById("elm1");
	Если ОбластьТекста = Неопределено Тогда
		//Сообщить("Не найдена область текста!", СтатусСообщения.Важное);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ОбластьТекста.innerText;
КонецФункции