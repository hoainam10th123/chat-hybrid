import { Photo } from "./photo";

export interface User{
    userName: string;
    token: string;
    photoUrl: string;
    displayName: string;
    lastActive: Date;
    dayOfBirth: Date;  
    roles: string[];
}

export interface Member{
    userName: string;
    displayName: string;
    lastActive: Date;
    dayOfBirth: Date;
    photoUrl: string;
    photos: Photo[];
    unReadMessageCount: number;
}