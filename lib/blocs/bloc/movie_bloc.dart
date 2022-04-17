import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_hive/hive_database.dart';
import 'package:flutter_hive/models/movie_model.dart';
import 'package:hive/hive.dart';
part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final HiveDatabase hiveDatabase;

  MovieBloc({required this.hiveDatabase}) : super(MovieLoading()) {
    on<LoadMovies>(_onLoadMovies);
    on<UpdateMovie>(_onUpdateMovie);
    on<AddMovie>(_onAddMovie);
    on<DeleteAllMovies>(_onDeleteAllMovies);
    on<DeleteMovie>(_onDeleteMovie);
  }

  void _onLoadMovies(
    LoadMovies event,
    Emitter<MovieState> emit,
  ) async {
    Future<void>.delayed(const Duration(seconds: 1));
    Box box = await hiveDatabase.openBox();
    List<Movie> movies = hiveDatabase.getMovies(box);
    emit(MovieLoaded(movies: movies));
  }

  void _onUpdateMovie(
    UpdateMovie event,
    Emitter<MovieState> emit,
  ) async {
    Box box = await hiveDatabase.openBox();
    if (state is MovieLoaded) {
      await hiveDatabase.updateMovie(box, event.movie);
      emit(MovieLoaded(movies: hiveDatabase.getMovies(box)));
    }
  }

  void _onAddMovie(
    AddMovie event,
    Emitter<MovieState> emit,
  ) async {
    Box box = await hiveDatabase.openBox();
    if (state is MovieLoaded) {
      await hiveDatabase.addMovie(box, event.movie);
      emit(MovieLoaded(movies: hiveDatabase.getMovies(box)));
    }
  }

  void _onDeleteAllMovies(
    DeleteAllMovies event,
    Emitter<MovieState> emit,
  ) async {
    Box box = await hiveDatabase.openBox();
    if (state is MovieLoaded) {
      hiveDatabase.deleteAllMovie(box);
      emit(MovieLoaded(movies: hiveDatabase.getMovies(box)));
    }
  }

  void _onDeleteMovie(
    DeleteMovie event,
    Emitter<MovieState> emit,
  ) async {
    Box box = await hiveDatabase.openBox();
    if (state is MovieLoaded) {
      hiveDatabase.deleteMovie(box, event.movie);
      emit(MovieLoaded(movies: hiveDatabase.getMovies(box)));
    }
  }
}
