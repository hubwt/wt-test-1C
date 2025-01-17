#Область ОбработчикиСобытий
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	// Комлев АА 17/01/25 +++
	Если Не дт_ОбщегоНазначенияВызовСервераПовтИсп.НомерУПДЗаполнен(ПараметрКоманды) Тогда
		Сообщить("Номер УПД не заполнен.");
		Возврат;
	КонецЕсли;

	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);  // выбор каталога
	ДиалогВыбораФайла.Заголовок = "Выберите каталог!";
	ДиалогВыбораФайла.ПолноеИмяФайла = ДиалогВыбораФайла.Каталог;
	
	
	Если ДиалогВыбораФайла.Выбрать() Тогда
		Каталог = ДиалогВыбораФайла.Каталог;
		Адрес =  дт_ОбщегоНазначенияВызовСервераПовтИсп.СоздатьXMLФайл(Каталог, ПараметрКоманды, "ЗаказНаряд");
		ДвоичныеДанные  =  ПолучитьИзВременногоХранилища(Адрес);
		ДвоичныеДанные.Записать(Каталог + "/" + дт_ОбщегоНазначенияВызовСервераПовтИсп.СформироватьНазваниеФайла(ПараметрКоманды, "ЗаказНаряд") + ".xml");
		УдалитьИзВременногоХранилища(Адрес);
	КонецЕсли;
	Сообщить("Файл сохранен.");
	// Комлев АА 17/01/25 ---
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти
