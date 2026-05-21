<?php

namespace App\Http\Controllers;

use App\Models\Note;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class NoteController extends Controller
{
    public function store(Request $request): JsonResponse
    {
        $user = $request->user();

        $data = $request->validate([
            'note_id' => ['required', 'string', 'max:255', 'unique:notes,note_id'],
            'note' => ['required', 'string', 'max:500'],
        ]);

        $note = Note::create([
            'user_id' => $user->id,
            'note_id' => $data['note_id'],
            'note' => $data['note'],
        ]);

        return response()->json([
            'message' => 'Note created successfully.',
            'note' => $note,
        ], 201);
    }
}
