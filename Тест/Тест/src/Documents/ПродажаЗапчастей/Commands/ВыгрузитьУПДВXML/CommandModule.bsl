#Область ОбработчикиСобытий
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОбъектыПечати = Новый СписокЗначений;
	ОбъектыПечати.Добавить(ПараметрКоманды);
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(ПараметрКоманды);
	ТабДок = СформироватьТабДок(ОбъектыПечати, МассивСсылок);
	Если ТабДок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыТабДокумента = СтруктураПараметровТабДок(ТабДок);
	//ТабДок.Записать("C:\ФайлыУПД\test.xls", ТипФайлаТабличногоДокумента.XLS);
	//Сериализовать(ПараметрКоманды);
	
	Сообщить("Файл скачан");
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Функция СформироватьТабДок(Знач ОбъектПечати, МассивСсылок)
	ПараметрыПечати = Новый Структура;
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивСсылок);
	ТабДок = Обработки.ПечатьОбщихФорм.СформироватьПечатнуюФормуУПД(СтруктураТипов, ОбъектПечати, ПараметрыПечати);
	Возврат ТабДок;
	
КонецФункции

&НаСервере
Процедура Сериализовать(Значение)
	Фабрика = Новый ФабрикаXDTO;
	Сериализатор = Новый СериализаторXDTO(Фабрика);
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл("C:\ФайлыУПД\test.xml");
	Сериализатор.ЗаписатьXML(ЗаписьXML, Значение);
	ЗаписьXML.Закрыть();
КонецПроцедуры


Функция СтруктураПараметровТабДок(ТабДок)	
	ВесьТабДокВСтроку = ЗначениеВСтрокуВнутр(ТабДок);
	Счетчик = 0; 
	КоличествоСтрок = СтрЧислоСтрок(ВесьТабДокВСтроку);  
	МассивСтрок = Новый Массив; 
	Пока Счетчик < КоличествоСтрок Цикл 
		Счетчик  = Счетчик + 1;
		ОчереднаяСтрока = СтрПолучитьСтроку(ВесьТабДокВСтроку, Счетчик);
		Если  СтрНачинаетсяС(ОчереднаяСтрока, "{""#""") Тогда 
			МассивИзСтроки = СтрРазделить(ОчереднаяСтрока, Символ(34));
			Если МассивИзСтроки.Количество() = 5 Тогда
				МассивСтрок.Добавить(МассивИзСтроки[3]);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла; 
	Возврат МассивСтрок;		 
КонецФункции

#КонецОбласти