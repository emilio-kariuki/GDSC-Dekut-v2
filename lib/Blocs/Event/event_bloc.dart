import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gdsc_bloc/Data/Models/developer_model.dart';
import 'package:gdsc_bloc/Data/Models/event_model.dart';
import 'package:gdsc_bloc/Data/Models/groups_model.dart';
import 'package:gdsc_bloc/Data/Models/resource_model.dart';
import 'package:gdsc_bloc/Data/Models/twitter_model.dart';
import 'package:gdsc_bloc/Data/Repository/providers.dart';
import 'package:gdsc_bloc/Util/shared_preference_manager.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc() : super(EventInitial()) {
    on<GetEvents>((event, emit) async {
      emit(EventLoading());
      try {
        final events = await Providers().getEvent();
        emit(EventSuccess(events: events));
      } catch (e) {
        emit(const EventFailure(message: "Failed to load events"));
      }
    });

    on<SearchEvent>((event, emit) async {
      emit(SearchEventLoading());
      try {
        final events = await Providers().searchEvent(query: event.query);
        emit(SearchEventSuccess(events: events));
      } catch (e) {
        emit(const SearchEventFailure(message: "Failed to load events"));
      }
    });

    on<GetSpaces>((event, emit) async {
      emit(TwitterLoading());
      try {
        final twitter = await Providers().getSpaces();
        emit(TwitterSuccess(spaces: twitter));
      } catch (e) {
        emit(const TwitterFailure(message: "Failed to load spaces"));
      }
    });

    on<SearchSpace>((event, emit) async {
      emit(SearchTwitterLoading());
      try {
        final spaces = await Providers().searchSpace(query: event.query);
        emit(SearchTwitterSuccess(spaces: spaces));
      } catch (e) {
        emit(const SearchEventFailure(message: "Failed to load events"));
      }
    });

    on<GetGroups>((event, emit) async {
      emit(GroupsLoading());
      try {
        final groups = await Providers().getGroups();
        emit(GroupsSuccess(groups: groups));
      } catch (e) {
        emit(const GroupsFailure(message: "Failed to load groups"));
      }
    });

    on<SearchGroup>((event, emit) async {
      emit(SearchGroupsLoading());
      try {
        final groups = await Providers().searchGroup(query: event.query);
        emit(SearchGroupsSuccess(groups: groups));
      } catch (e) {
        emit(const SearchEventFailure(message: "Failed to load groups"));
      }
    });

    on<GetResource>((event, emit) async {
      emit(ResourceLoading());
      try {
        final resource =
            await Providers().getResources(category: event.category);
        emit(ResourceSuccess(resources: resource));
      } catch (e) {
        emit(const ResourceFailure(message: "Failed to load resources"));
      }
    });

    on<GetUserResources>((event, emit) async {
      emit(UserResourceLoading());
      try {
        final userId = await SharedPreferencesManager().getId();
        final resource = await Providers().getUserResources(userId: userId);
        emit(UserResourceSuccess(resources: resource));
      } catch (e) {
        emit(const UserResourceFailure(message: "Failed to load resources"));
      }
    });

    on<SearchUserResource>((event, emit) async {
      emit(SearchUserResourceLoading());
      try {
        final userId = await SharedPreferencesManager().getId();
        final resource = await Providers()
            .searchUserResources(query: event.query, userId: userId);
        emit(SearchUserResourceSuccess(resources: resource));
      } catch (e) {
        emit(const SearchEventFailure(message: "Failed to load resources"));
      }
    });

    on<GetDevelopers>((event, emit) async {
      emit(DeveloperLoading());
      try {
        final developers = await Providers().getDevelopers();
        emit(DeveloperSuccess(developers: developers));
      } catch (e) {
        emit(const DeveloperFailure(message: "Failed to load developers"));
      }
    });
  }
}
