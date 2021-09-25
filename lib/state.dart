import 'package:flutter/material.dart';
import 'package:functional_listener/functional_listener.dart';
import 'package:flutter/foundation.dart';
import 'package:built_collection/built_collection.dart';
import 'models/calendar.dart';
import 'dart:async';
import 'dart:io';
import 'models.dart';
import 'models/master.dart';
import 'utils.dart';


var notifyAfterEvent = Map<Type, ValueNotifier>();

mixin UIEventsDesc {
  String get desc => "";
  
  String toString() {
    return "${runtimeType} ${desc}";
  }
}

abstract class UIEvent {
  
  void perform() {
  }

}

abstract class StateEvent {
  
}

void emit(UIEvent event) {
  print(event);
  event.perform();
  
  notifyAfterEvent[event.runtimeType]?.value++;
}

afterEvent(events, notifier) {
  events.map((e) =>
    notifyAfterEvent[e] = notifier
  );
}



class AppState {

  static void init() {
    Calendar.init();
  }
  
  static var clients = ValueNotifier<BuiltSet<Client>>(BuiltSet([
        Client(
          id: '1',
          firstName: 'Мария',
          phoneNumber: "+5806740555"
        ),
        Client(
          id: '2',
          firstName: 'Дарья',
          phoneNumber: "+5806740555"
        ),
        Client(
          id: '3',
          firstName: 'Валентина',
          phoneNumber: "+5806740555"
        ),
        Client(
          id: '1',
          firstName: 'Мария',
          phoneNumber: "+5806740555"
        ),
        Client(
          id: '2',
          firstName: 'Дарья',
          phoneNumber: "+5806740555"
        ),
        Client(
          id: '3',
          firstName: 'Валентина',
          phoneNumber: "+5806740555"
        ),
        Client(
          id: '1',
          firstName: 'Мария',
          phoneNumber: "+5806740555"
        ),
        Client(
          id: '2',
          firstName: 'Дарья',
          phoneNumber: "+5806740555"
        ),
        Client(
          id: '3',
          firstName: 'Валентина',
          phoneNumber: "+5806740555"
        ),
        Client(
          id: '1',
          firstName: 'Мария',
          phoneNumber: "+5806740555"
        ),
        Client(
          id: '2',
          firstName: 'Дарья',
          phoneNumber: "+5806740555"
        ),
        Client(
          id: '3',
          firstName: 'Валентина',
          phoneNumber: "+5806740555"
        )
    ])
  );

  static var masters = ValueNotifier<BuiltSet<Master>>(BuiltSet([
        Master(
          id: "1",
          firstName: "Masha",
          services: serv(["1", "2", "3", "5"]),
          workingHours7days: BuiltSet()
        ),
        Master(
          id: "2",
          firstName: "Dasha",
          services: serv(["1", "2"]),
          workingHours7days: BuiltSet()
        ),
        Master(
          id: "3",
          firstName: "Pasha",
          services: serv(["4", "5"]),
          workingHours7days: BuiltSet()
        ),
    ])
  );

  static var services = ValueNotifier(
    Set<Service>.unmodifiable([
        Service(
          id: "1",
          cat: 'Стрижки', name: 'Укладка',
          price: 100, duration: 15
        ),
        Service(
          id: "2",
          cat: 'Стрижки', name: 'Стрижка мужская',
          price: 100, duration: 15
        ),
        Service(
          id: "3",
          cat: 'Стрижки', name: 'Стрижка бороды',
          price: 100, duration: 15
        ),
        Service( 
          id: "4",
          cat: 'Стрижки', name: 'Стрижка женская',
          price: 100, duration: 15
        ),
        Service(
          id: "5",
          cat: 'Визаж и дизайн бровей', name: 'Light make-up',
          price: 100, duration: 15
        ),
        Service(
          id: "6",
          cat: 'Визаж и дизайн бровей', name: 'Дневной make-up',
          price: 100, duration: 15
        ),
    ])
  );
  
  static var events = BuiltSet<Event>([
      Event(
        id: "1",
        services: serv(["1"]),
        startAt: today().atTime(10, 30),
        client: clients.value.first,
        master: masters.value.first,
        duration: Duration(minutes: 30),
      ),
      Event(
        id: "2",
        services: serv(["2"]),
        startAt: today().add(Duration(days: 1)).atTime(11, 30),
        client: clients.value.first,
        master: masters.value.first,
        duration: Duration(minutes: 30),
      ),
      Event(
        id: "3",
        services: serv(["3"]),
        startAt: today().add(Duration(days: 2)).atTime(12, 30),
        client: clients.value.first,
        master: masters.value.first,
        duration: Duration(minutes: 30),
      )
  ]);
  
  static BuiltSet<Service> serv(List<String> ids) {
    return services.value
    .where((s) => ids.contains(s.id))
    .toSet()
    .build();
  }
}
