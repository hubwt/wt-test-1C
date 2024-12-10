
&НаКлиенте
Процедура СписокТМЦПриИзменении(Элемент)
	// ++ МазинЕС 09-12-24	
	Если ЗначениеЗаполнено(Объект.ДоставкаСумма) ТОгда 
			
		СуммаКоличество = объект.СписокТМЦ.Итог("Количество"); 
		ЕдиницаДоставки = Объект.ДоставкаСумма /  СуммаКоличество; 
		
		Для Каждого Строка ИЗ Объект.СписокТМЦ Цикл 
			Строка.Доставка = ЕдиницаДоставки; 	
		КонецЦикла; 	
					
	КонецЕсли; 
// -- МазинЕС 09-12-24	
КонецПроцедуры

&НаКлиенте
Процедура ДоставкаСуммаПриИзменении(Элемент)
		// ++ МазинЕС 09-12-24	
	Если ЗначениеЗаполнено(Объект.ДоставкаСумма) ТОгда 
			
		СуммаКоличество = объект.СписокТМЦ.Итог("Количество"); 
		ЕдиницаДоставки = Объект.ДоставкаСумма /  СуммаКоличество; 
		
		Для Каждого Строка ИЗ Объект.СписокТМЦ Цикл 
			Строка.Доставка = ЕдиницаДоставки; 	
		КонецЦикла; 	
					
	КонецЕсли; 
// -- МазинЕС 09-12-24	
КонецПроцедуры


&НаСервере
Функция ПолучитьРодителяВидыРасходов_3()
	
	Родитель = Справочники.ВидыРасходов_3.НайтиПоКоду("000000001");
	Возврат Родитель ;

КонецФункции

&НаКлиенте
Процедура ФилиалНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Объект.Отдел 				= Неопределено; 
	Объект.ВидыРасхода_3 	= Неопределено; 
	Объект.Категория 		= Неопределено;
	Объект.Статья 			= Неопределено;
	
	
	
	СтандартнаяОбработка = ЛОЖЬ;
    Родитель = ПолучитьРодителяВидыРасходов_3();
    Отбор = Новый Структура();
    Отбор.Вставить("Родитель", Родитель);
    Отбор.Вставить("ПометкаУдаления", ЛОЖЬ);
    Отбор.Вставить("ЭтоГруппа", ЛОЖЬ);
    Отбор.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
    
    ПараметрыФормы = Новый Структура();
    ПараметрыФормы.Вставить("РежимВыбора", ИСТИНА);
    ПараметрыФормы.Вставить("МножественныйВыбор", ЛОЖЬ);
    ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", ИСТИНА);
    ПараметрыФормы.Вставить("РазрешитьВыборКорня", ЛОЖЬ);
    ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
    ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца", ИСТИНА);
    ПараметрыФормы.Вставить("ТолькоПросмотр", ЛОЖЬ);
	ПараметрыФормы.Вставить("Отбор", Отбор);

	ОбработкаВыбора = Новый ОписаниеОповещения("ПриЗакрытииФормыВыбора", ЭтаФорма,"Филиал");
	Форм = ОткрытьФорму("Справочник.ВидыРасходов_3.Форма.ФормаВыбора",ПараметрыФормы,
	ЭтаФорма, , , , ОбработкаВыбора);
	Форм.Элементы.Список.Отображение = ОтображениеТаблицы.Список;
	Форм.Заголовок = "Категории расходов";
КонецПроцедуры

&НаКлиенте
Процедура ОтделНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		 
	Объект.ВидыРасхода_3 	= Неопределено; 
	Объект.Категория 		= Неопределено;
	Объект.Статья 			= Неопределено;
	
	СтандартнаяОбработка = ЛОЖЬ;
    
    Отбор = Новый Структура();
    Отбор.Вставить("Родитель", объект.Филиал);
    Отбор.Вставить("ПометкаУдаления", ЛОЖЬ);
    Отбор.Вставить("ЭтоГруппа", ЛОЖЬ);
    Отбор.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
    
    ПараметрыФормы = Новый Структура();
    ПараметрыФормы.Вставить("РежимВыбора", ИСТИНА);
    ПараметрыФормы.Вставить("МножественныйВыбор", ЛОЖЬ);
    ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", ИСТИНА);
    ПараметрыФормы.Вставить("РазрешитьВыборКорня", ЛОЖЬ);
    ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
    ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца", ИСТИНА);
    ПараметрыФормы.Вставить("ТолькоПросмотр", ЛОЖЬ);
	ПараметрыФормы.Вставить("Отбор", Отбор);

	ОбработкаВыбора = Новый ОписаниеОповещения("ПриЗакрытииФормыВыбора", ЭтаФорма,"Отдел");
	Форм = ОткрытьФорму("Справочник.ВидыРасходов_3.Форма.ФормаВыбора",ПараметрыФормы,
	ЭтаФорма, , , , ОбработкаВыбора);
	Форм.Элементы.Список.Отображение = ОтображениеТаблицы.Список;
	Форм.Заголовок = "Категории расходов";
КонецПроцедуры

&НаКлиенте
Процедура СтатьяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = ЛОЖЬ;
				
			 	Отбор = Новый Структура();
			   Отбор.Вставить("РодительРодительРодитель", Объект.Отдел);
			   Отбор.Вставить("ПометкаУдаления", ЛОЖЬ);
			   Отбор.Вставить("ЭтоГруппа", ЛОЖЬ);
			   Отбор.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
			    
			   ПараметрыФормы = Новый Структура();
			   ПараметрыФормы.Вставить("РежимВыбора", ИСТИНА);
			   ПараметрыФормы.Вставить("МножественныйВыбор", ЛОЖЬ);
			   ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", ИСТИНА);
			   ПараметрыФормы.Вставить("РазрешитьВыборКорня", ЛОЖЬ);
			   ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
			   ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца", ИСТИНА);
			   ПараметрыФормы.Вставить("ТолькоПросмотр", ЛОЖЬ);
				ПараметрыФормы.Вставить("Отбор", Отбор);
			
				ОбработкаВыбора = Новый ОписаниеОповещения("ПриЗакрытииФормыВыбора", ЭтаФорма,"Статья");
				Форм = ОткрытьФорму("Справочник.ВидыРасходов_3.Форма.ФормаВыбора",ПараметрыФормы,
				ЭтаФорма, , , , ОбработкаВыбора);
				Форм.Элементы.Список.Отображение = ОтображениеТаблицы.Список;
				Форм.Заголовок = "Категории расходов";
КонецПроцедуры

ФУНКЦИЯ ОпределитьКатегориюСтатьи(Значение)
	
	Возврат Значение.Родитель; 
	
КонецФункции
ФУНКЦИЯ ОпределитьВидСтатьи(Значение)
	
	Возврат Значение.Родитель.Родитель; 
	
КонецФункции

ФУНКЦИЯ ОпределитьОргСтруктураРасходыКод(Значение)
	
	Возврат Значение.ОргСтруктураРасходы.Код; 
	
КонецФункции

&НаКлиенте
Процедура ПриЗакрытииФормыВыбора(Значение, ДопПараметры) Экспорт

   //Дополнительные условия если необходимо
   Если ДопПараметры = "Филиал" тогда

    	Если Значение = Неопределено Тогда  ///Если ничего не выбрать - вернется пустое значение (Неопределено)
        	Возврат;
    	КонецЕсли;
    	Объект.Филиал = Значение ///Если Множественный Выбор - то вернется массив 
    
    ИНачеЕсли ДопПараметры = "Отдел" тогда
		
		Если Значение = Неопределено Тогда  ///Если ничего не выбрать - вернется пустое значение (Неопределено)
        	Возврат;
    	КонецЕсли;
    	Объект.Отдел = Значение; ///Если Множественный Выбор - то вернется массив
   		//ЗаполнениеСпискаВлияние(); 
     ИНачеЕсли ДопПараметры = "Категория" тогда
		
		Если Значение = Неопределено Тогда  ///Если ничего не выбрать - вернется пустое значение (Неопределено)
        	Возврат;
    	КонецЕсли;
    	Объект.Категория = Значение ///Если Множественный Выбор - то вернется массив
   
   ИНачеЕсли ДопПараметры = "Статья" тогда
		
		Если Значение = Неопределено Тогда  ///Если ничего не выбрать - вернется пустое значение (Неопределено)
        	Возврат;
    	КонецЕсли;
    	Объект.Статья = Значение;  ///Если Множественный Выбор - то вернется массив
   		
   		Если НЕ ЗначениеЗаполнено(Объект.Категория) ТОгда 
   			Объект.Категория = ОпределитьКатегориюСтатьи(Значение);
   		КонецЕсли;  
   		
   		Если НЕ ЗначениеЗаполнено(Объект.ВидыРасхода_3) ТОгда 
   			Объект.ВидыРасхода_3 = ОпределитьВидСтатьи(Значение);
   		КонецЕсли;
   		
   		
   ИНачеЕсли ДопПараметры = "Статья2" тогда
		
		Если Значение = Неопределено Тогда  ///Если ничего не выбрать - вернется пустое значение (Неопределено)
        	Возврат;
    	КонецЕсли;
    	Объект.Статья = Значение ///Если Множественный Выбор - то вернется массив
   
   ИНачеЕсли ДопПараметры = "Виды_Расходов_3" тогда
		
		Если Значение = Неопределено Тогда  
        	Возврат;
    	КонецЕсли;
    	
    	Объект.ВидыРасхода_3 = Значение;  
   	
   		Если ОпределитьОргСтруктураРасходыКод(Значение)  =  "000000003" Тогда  // 03 - Зарплата / 04 - расход
        		Элементы.Категория.ТолькоПросмотр = ложь; 
        	Иначе Элементы.Категория.ТолькоПросмотр = Истина; 
    		КонецЕсли;
   	
    КонецЕсли;
   
КонецПроцедуры

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	///+ГомзМА 13.04.2023
	ИнвентарныеНомера.Параметры.УстановитьЗначениеПараметра("ДокументПоступления", Объект.Ссылка);
	///-ГомзМА 13.04.2023
	
	
	/// Комлев 04/07/24 +++
	Если Объект.Ссылка.Пустая() или (не ЗначениеЗаполнено(объект.Ответственный)) Тогда
        Объект.Ответственный =  ПользователиКлиентСервер.ТекущийПользователь();
    КонецЕсли;
	
	/// Комлев 04/07/24 ---
КонецПроцедуры


&НаКлиенте
Процедура СписокТМЦТМЦПриИзменении(Элемент)
	
	ТекСтрока = Элементы.СписокТМЦ.ТекущиеДанные;
		
	Если НЕ ЗначениеЗаполнено(ТекСтрока.Количество) Тогда
		ТекСтрока.Количество = 1;
	КонецЕсли;
	ТекСтрока.Склад = Объект.Склад;
	Код        	 	= РаботаСДокументамиТМЦВызовСервера.ПолучениеКодаТМЦ(ТекСтрока.ТМЦ);

	ТекСтрока.Код = Код;
	ОбработкаИзмененияСтроки("СписокТМЦ", "Цена");
	
	СписокТМЦТМЦПриИзмененииНаСервере(ТекСтрока.ТипУчета);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТМЦКоличествоПриИзменении(Элемент)
	ОбработкаИзмененияСтроки("СписокТМЦ", "Количество");
КонецПроцедуры

&НаКлиенте
Процедура СписокТМЦЦенаПриИзменении(Элемент)
	ОбработкаИзмененияСтроки("СписокТМЦ", "Цена");
КонецПроцедуры


&НаСервере
Процедура СписокТМЦТМЦПриИзмененииНаСервере(ТипУчета)

	///+ГомзМА 26.04.2023
	ТипУчета = Перечисления.ТипУчетаТМЦ.УчестьКомплектом;
	///-ГомзМА 26.04.2023

КонецПроцедуры





#КонецОбласти

#Область ОбработчикиКомандФормы



#КонецОбласти

#Область СлужебныеПроцедурыИФункции


&НаКлиенте
Процедура ОбработкаИзмененияСтроки(ИмяТабличнойЧасти, Поле = Неопределено, ДанныеСтроки = Неопределено) Экспорт
	
	ТекДанные = ?(ДанныеСтроки = Неопределено, Элементы[ИмяТабличнойЧасти].ТекущиеДанные, ДанныеСтроки);
	
	Если Поле = "Сумма" Тогда
		Если ТекДанные.Количество <> 0 Тогда
			ТекДанные.Цена = ТекДанные.Сумма / ТекДанные.Количество;
		КонецЕсли;	
	Иначе	
		ТекДанные.Сумма = ТекДанные.Цена * ТекДанные.Количество;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаИзмененияСтроки()

&НаКлиенте
Процедура ИнвентарныеНомераВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		
	///+ГомзМА 22.05.2023
	ТекСтрока = Элементы.ИнвентарныеНомера.ТекущиеДанные;
	Если Поле = Элементы.ИнвентарныеНомераСсылка Тогда
		
		СсылкаДляОткрытия    = ТекСтрока.Ссылка;
		ПараметрыФормы       = Новый Структура("Ключ", СсылкаДляОткрытия);
		
		ФормаДокумента 		 = ПолучитьФорму("Справочник.ИнвентарныеНомера.Форма.ФормаЭлемента", ПараметрыФормы);
		ФормаДокумента.Открыть();
	КонецЕсли;
	///+ГомзМА 22.05.2023
	
КонецПроцедуры



&НаСервере
Процедура ПослеЗаписиНаСервере1(ТекущийОбъект, ПараметрыЗаписи)
	
	///+ГомзМА 28.07.2023
	ИнвентарныеНомера.Параметры.УстановитьЗначениеПараметра("ДокументПоступления", Объект.Ссылка);
	///-ГомзМА 28.07.2023
	
КонецПроцедуры

&НаКлиенте
Процедура СчетПриИзменении(Элемент)
	
	///+ГомзМА 29.09.2023
	СчетПриИзмененииНаСервере();
	///-ГомзМА 29.09.2023
	
КонецПроцедуры


&НаСервере
Процедура СчетПриИзмененииНаСервере()
	
	///+ГомзМА 29.09.2023
	Объект.Организация = Объект.Счет.Владелец;
	///-ГомзМА 29.09.2023
	
КонецПроцедуры




#КонецОбласти






