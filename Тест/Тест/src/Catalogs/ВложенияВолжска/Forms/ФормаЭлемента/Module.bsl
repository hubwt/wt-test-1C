

//Мазин -----------------------------------Начало
&НаКлиенте
Процедура СуммаДолгаПриИзменении(Элемент)
	СуммаДолгаПриИзмененииНаСервере();
	СтатусПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
СтатусПриИзмененииНаСервере(); 	
КонецПроцедуры


&НаСервере
Процедура СуммаДолгаПриИзмененииНаСервере()
			
//Перебор таблицы Справочника Кредит (ВложенияВолжская) и заполнение реквизитов
 		СуммаПлатежей = 0; 
 	Для Каждого СтрокаТЧ ИЗ Объект.Погашения Цикл 
 		СуммаПлатежей= СуммаПлатежей + СтрокаТЧ.Сумма;  	
 	КонецЦикла;
 		Объект.ОплаченоПоКредиту = СуммаПлатежей; 
 		Объект.ОсталосьОтбить = Объект.СуммаДолга - СуммаПлатежей; 
	
// Реквизит Статус справочника Кредит (ВложенияВолжская)		
		Если Объект.ОсталосьОтбить <= 0 ТОГДА 
			Объект.Статус = Перечисления.СтатусКредита.Закрыто;
		ИНАЧЕ 
			Объект.Статус = Перечисления.СтатусКредита.Открыто 
	КонецЕсли;
			
КонецПроцедуры

&НаСервере
Процедура СтатусПриИзмененииНаСервере()
// Заполнение реквизита - Статус в документе ПриходОтКредитов

Запрос = Новый Запрос;
Запрос.Текст =
	"ВЫБРАТЬ
	|	ПриходОтКредитов.Ссылка КАК СсылкаКред
	|ИЗ
	|	Документ.ПриходОтКредитов КАК ПриходОтКредитов
	|ГДЕ
	|	ПриходОтКредитов.КредитВБанке = &КредитВБанке";

Запрос.УстановитьПараметр("КредитВБанке", Объект.Ссылка);

РезультатЗапроса = Запрос.Выполнить();
	СсылкаНаПриходКред=Неопределено;
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
Пока ВыборкаДетальныеЗаписи.Следующий() Цикл	
	СсылкаНаПриходКред =ВыборкаДетальныеЗаписи.СсылкаКред; 
КонецЦикла;

Попытка
ОбъектПриходОтКредитов = СсылкаНаПриходКред.ПолучитьОбъект(); 
ОбъектПриходОтКредитов.Статус = Объект.Статус; 
ОбъектПриходОтКредитов.Записать(); 
Исключение
Сообщение = Новый СообщениеПользователю; 
Сообщение.Текст = "Не Забудте Создать Документ Приход От Кредитов";
Сообщение.Сообщить();
КонецПопытки
КонецПроцедуры




//Мазин -----------------------------------Конец




