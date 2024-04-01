
&НаКлиенте
Процедура ВыполнитьПеремещение(Команда)
	// Вставить содержимое обработчика.
	Если ИзКат.Пустая() = Истина ИЛИ ВКат.Пустая() = Истина Тогда
		Сообщить("Необходимо выбрать категорию откуда и куда перемещать товары");
		Возврат;
	КонецЕсли;
	
	рез = Вопрос(ПроверитьПеремещение(),РежимДиалогаВопрос.ДаНет);
	Если рез = КодВозвратаДиалога.Да Тогда
		Переместить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьПеремещение()
	з = Новый Запрос;
	з.Текст =  "ВЫБРАТЬ
	           |	Номенклатура.Ссылка
	           |ИЗ
	           |	Справочник.Номенклатура КАК Номенклатура
	           |ГДЕ
	           |	Номенклатура.Подкатегория2 = &Категория" ;
    з.УстановитьПараметр("Категория",ИзКат);
	рез = з.Выполнить().Выгрузить();
	сообщ = "Будет перемещено " + рез.Количество() + "товаров из категории "+ИзКат.Наименование+" в категорию "+ВКат.Наименование+". Вы Согласны?";
	возврат сообщ;
КонецФункции

&НаСервере
Процедура Переместить()
	з = Новый Запрос;
	з.Текст =  "ВЫБРАТЬ
	           |	Номенклатура.Ссылка
	           |ИЗ
	           |	Справочник.Номенклатура КАК Номенклатура
	           |ГДЕ
	           |	Номенклатура.Подкатегория2 = &Категория" ;
    з.УстановитьПараметр("Категория",ИзКат);
	рез = з.Выполнить().Выгрузить();
	Для Каждого стр Из рез Цикл;
		об = стр.Ссылка.ПолучитьОбъект();
		об.Подкатегория2 = ВКат;
		об.Записать();
	КонецЦикла;
КонецПроцедуры

	
	