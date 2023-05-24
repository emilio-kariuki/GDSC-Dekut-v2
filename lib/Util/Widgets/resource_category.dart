import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/Blocs/Event/event_bloc.dart';
import 'package:gdsc_bloc/Util/Widgets/loading_circle.dart';
import 'package:gdsc_bloc/Util/Widgets/no_resource_found.dart';
import 'package:gdsc_bloc/Util/Widgets/resources_card.dart';


class ResourceCategory extends StatelessWidget {
  const ResourceCategory({
    super.key,
    required this.height,
    required this.width,
    required this.category,
    required this.image,
  });

  final double height;
  final double width;
  final String category;
  final String image;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventBloc()..add(GetResource(category: category)),
      child: Builder(builder: (context) {
        return BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            if (state is ResourceLoading) {
              return const Center(child: LoadingCircle());
            } else if (state is ResourceSuccess) {
              return SizedBox(
                height: height * 0.18,
                child: state.resources.isEmpty
                    ? Center(
                      child: NoResourceCard(
                          height: height,
                          width: width,
                        ),
                    )
                    : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: state.resources.length,
                        itemBuilder: (context, index) {
                          final data = state.resources[index];
                          return ResourceCard(
                            width: width,
                            height: height,
                            image: image,
                            title: data.title!,
                          );
                        }),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      }),
    );
  }
}
